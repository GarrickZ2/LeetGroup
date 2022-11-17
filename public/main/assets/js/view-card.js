// initialize modal
$( document ).ready(function() {
    // initialize bootpag and generate cards from data
    generateAllCardsBasedOnPage(1);
    $('.pagination-here').bootpag({
    }).on("page", function(event, num) {
        generateAllCardsBasedOnPage(num);
    });

    // show modal and put data into modal
    $('#cardViewModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget) // Button that triggered the modal
        var cid = button.data('cid') // Extract info from data-* attributes
        // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
        var cardDetail = []
        let detailData = {
            "uid": $("#uid").val(),
            "cid": cid
        };
        $.ajax ({
            url:"card/detail",
            type:"GET",
            data: detailData,
            success: function(data) {
                cardDetail = Object.values(data)[0];
                putCardDetail(cardDetail,cid);
            },
            error: function(){
                alert("Fail to get card details");
            }
        });
    });

    $('#userGroupModal').on('show.bs.modal', function (event) {
        let uid = $("#uid").val();
        // // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
        var groupDetails = [];
        $.ajax ({
            url:"user/" + uid + "/group",
            type:"GET",
            success: function(data) {
                groupData = data["groups"];
                generateGroupDetail(groupData);
            },
            error: function(){
                alert("Fail to get group details");
            }
        });
    });
});


function putCardDetail(cardDetail, cid) {
    $('#card-view-title').val(cardDetail["title"]);
    $('#card-view-description').text(cardDetail["description"]);
    $('#card-view-source').val(cardDetail["source"]);
    $('#card-view-create-time').text(processDate(cardDetail["create_time"]));
    $('#card-view-star').text("Star " + cardDetail["stars"]);
    $('#card-view-used-time').text(processUsedTime(cardDetail["used_time"]));
    $('#delete-card-cid').val(cid);
}


// function to generate all view cards
function generateAllCardsBasedOnPage(offset) {
    let uid = $("#uid").val();
    let pagination_data = {
        "uid": uid,
        "status": 3 ,
        "page_size": 6,
        "offset": offset - 1,
        "sort_by": "create_time",
        "sort_type": "asc"
    };
    // get card info and page info data
    var cardData = [];
    var pageData = [];
    $.ajax ({
        url:"/card/view",
        type:"POST",
        data: pagination_data,
        success: function(data) {
            cardData = data["card_info"];
            pageData = data["page_info"];
            generateCardDetail(cardData);
            generatePagination(JSON.parse(pageData), offset);
        },
        error: function(){
            alert("Fail to get card data");
        }
    });
}

// generate pagination based on the page info
function generatePagination(pageData, offset) {
    $('.pagination-here').bootpag({
        total: pageData["total_page"],
        page: offset,
        maxVisible: 5,
        leaps: true,
        activeClass: "active-page"
    });
    // add class style for pagination
    $('[data-lp]').addClass('page-item');
    $('.page-item > a').addClass('page-link');
}


// function to generate each card detail modal content
function generateCardDetail(cardData) {
    // get the card results container
    let card_container = $("#card-results");
    // empty the container
    card_container.empty();
    if (Object.keys(cardData).length === 0) {
        let card_empty_text = $("<h5 class=\"card-title\"></h5>");
        card_empty_text.text("No card. Go create your card.");
        card_container.append(card_empty_text);
    } else{
        $.each(cardData, function(i, data) {
            let datum = JSON.parse(data);
            let card_col = $("<div class=\"col\">")
            let card_div = $("<div class=\"card\">")
            card_container.append(card_col)
            card_col.append(card_div)
            let card_body = $("<div class=\"card-body\">")
            let card_title = $("<h5 class=\"card-title\"></h5>")
            card_title.attr("id", "card-title-"+datum["cid"]);
            let card_text = $("<p class=\"card-text\">");
            card_text.attr("id", "card-text-"+datum["cid"]);
            let card_link = $("<a class=\"btn btn-inverse-secondary card-details-btn\"  data-toggle=\"modal\" data-target=\"#cardViewModal\" >See detail</a>")
            card_link.attr("data-cid", datum["cid"]);
            card_link.attr("id", "card-detail-btn-"+datum["cid"]);

            // card body
            card_title.text(datum["title"])
            card_text.text(datum["source"])
            card_body.append(card_title)
            card_body.append(card_text)
            card_body.append(card_link)
            card_div.append(card_body)
        });
    }
}


function generateGroupDetail(groupData) {
    let group_body = $("#group-results");
    // empty the body
    group_body.empty();
    $("#share-card-notice").empty();

    let gid_list = [];
    if (JSON.parse(groupData).length == 0) {
        let group_empty_text = $("<h5></h5>");
        group_empty_text.text("No group. Go create/join your group.");
        group_body.append(group_empty_text);
        $("#share_button").remove();
    } else{

        $.each(JSON.parse(groupData), function(i, data) {
            console.log(data);
            gid_list.push(data["gid"]);
            let groupOption = "<label>"
                + "<input name='group_items' type='checkbox' value="
                + data["gid"] + " id=group_" + data["gid"] +">"
                + data["name"] + "</label> <br>";
            group_body.append(groupOption);
        });


        let gidList = {
            "gid_list": gid_list
        }

        // checked those groups that have included this card
        $.ajax ({
            url:"card/" + $("#delete-card-cid").val() + "/check_exist",
            type:"POST",
            data: gidList,
            success: function(data) {
                console.log("Check result:");
                console.log(data);
                $.each(data["exist_list"], function(i, singledata){
                    $("#group_" + singledata).attr("checked", true);
                    $("#group_" + singledata).attr("disabled", true);
                });
            },
            error: function(){
                alert("Fail to check card existence in groups");
            }
        });
    }
}

// Card: Edit
function editCard() {
    // get the data and send ajax request
    let edit_data = {
        "uid": $("#uid").val(),
        "title": $("#card-view-title").val(),
        "source": $("#card-view-source").val() ,
        "description": $("#card-view-description").val()
    };
    console.log("debug edit ", edit_data)
    $.ajax ({
        url:"/card/" + $("#delete-card-cid").val() + "/edit",
        type:"POST",
        data: edit_data,
        success: function(data) {
           if(data["success"]) {
               let cid = $("#delete-card-cid").val()
               $('#card-title-'+ cid).text($("#card-view-title").val());
               $('#card-text-'+ cid).text($("#card-view-source").val());
               show_notice_with_text("Successfully saved the changes");
           }else {
               alert(data["msg"]);
           }
        },
        error: function(){
            alert("Fail to edit the card");
        }
    });
}



// Card: Delete
function deleteCard() {
    $.ajax ({
        url:"/card/delete?uid=" + $("#uid").val() + "&cid=" + $("#delete-card-cid").val(),
        type:"GET",
        success: function(data) {
            // @TODO add successfully delete the card message and close the modal
            if(data["success"]) {
                // close the modal
                $('#close-delete-card-btn').click();
                $('#close-card-detail-btn').click();
                show_notice_with_text("Successfully delete the card");
                // rerender all cards based on page
                setTimeout(generateAllCardsBasedOnPage($(".active-page").text()), 1500);
            }else {
                alert("Fail to delete the card. Please try again.");
            }

        },
        error: function(){
            alert("Fail to delete the card");
        }
    });
}

function shareCard() {
    var group_list = [];
    $("input[name=group_items]:checkbox:checked").each(function(){
        group_list.push($(this).val());
    });
    console.log(group_list);
    let share_data = {
        "gid_list": group_list
    }
    $.ajax ({
        url: "card/" + $("#delete-card-cid").val() + "/share",
        type:"POST",
        data: share_data,
        success: function(data) {
            if(data["success"]) {
                console.log('success!');
                $("#share-card-notice").text('The card is shared successfully!');
                setTimeout("window.location.href = '/main/all_cards'", 500);
            }
            else {
                alert("Fail to share the card. Please try again.");
            }
        },
        error: function(){
            alert("Fail to share the card");
        }
    });
}

// Card: Add star
function changeStarIcon() {
    let data = {
        "uid": $("#uid").val(),
        "cid": $("#delete-card-cid").val()
    }
    // $.ajax ({
    //     url:"card/addStar",
    //     type:"POST",
    //     data: data,
    //     success: function(data) {
    //         // @TODO change the star number
    //         let star_icon = $(".star-icon");
    //         star_icon.removeClass("mdi-star-outline");
    //         star_icon.addClass("mdi-star");
    //         $('#card-view-star').text("Star " + data);
    //     },
    //     error: function(){
    //         alert("Fail to add star to the card");
    //     }
    // });

}

// helper function
function processDate(date) {
    return new Date(Date.parse(date)).toLocaleString()
}

// helper function
function processUsedTime(totalSeconds) {
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;

    function padTo2Digits(num) {
        return num.toString().padStart(2, '0');
    }

    // format as MM:SS
    const result = `${padTo2Digits(minutes)}:${padTo2Digits(seconds)}`;
    return result;
}


