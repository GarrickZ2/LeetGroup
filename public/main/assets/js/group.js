$( document ).ready(function() {
    // generate group cards tab and pagination
    generateCardsBasedOnPage(1);
    $('.pagination-cards').bootpag({
    }).on("page", function(event, num) {
        generateCardsBasedOnPage(num);
    });

    $('#cardViewModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget) // Button that triggered the modal
        var cid = button.data('cid') // Extract info from data-* attributes
        // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
        var cardDetail = [];
        $.ajax ({
            url:"/group/" + $("#gid").val() + "/card_detail/" + cid,
            type:"GET",
            success: function(data) {
                cardDetail = Object.values(data)[0];
                putCardDetail(cardDetail,cid);
            },
            error: function(){
                alert("Fail to get card details");
            }
        });
    });

    $('#deleteGroupCardModal').on('show.bs.modal', function (event) {
        let uid = $("#uid").val();
        // // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
        let permission = 0;
        $.ajax ({
            url: $("#gid").val() + "/check_permission/" + uid + "/" + $('#delete-card-cid').val(),
            type:"GET",
            success: function(data) {
                permission = data["result"];
                deleteGroupCard(permission);
            },
            error: function(){
                alert("Fail to get group details");
            }
        });
    });

    // @TODO generate setting tab

});

function putCardDetail(cardDetail, cid) {
    $('#card-view-title').val(cardDetail["title"]);
    $('#card-view-description').text(cardDetail["description"]);
    $('#card-view-source').text(cardDetail["source"]);
    $('#card-view-create-time').text(processDate(cardDetail["create_time"]));
    $('#card-view-star').text("Star " + cardDetail["stars"]);
    $('#card-view-used-time').text(processUsedTime(cardDetail["used_time"]));
    $('#delete-card-cid').val(cid);
}

// function to generate all cards
function generateCardsBasedOnPage(offset) {
    let gid = $("#gid").val();
    console.log("gid is", gid);
    let pagination_data = {
        "status": 3 ,
        "page_size": 6,
        "offset": offset - 1,
        "sort_by": "create_time",
        "sort_type": "asc"
    };
    // get card info and page info data
    var cardData = [];
    var pageData = [];
    // @TODO need to change to get group cards
    $.ajax ({
        url: "/group/" + gid + "/cards",
        type:"POST",
        data: pagination_data,
        success: function(data) {
            cardData = data["card_info"];
            pageData = data["page_info"];
            console.log(cardData);
            generateAllCards(cardData);
            generatePagination(JSON.parse(pageData), offset);
        },
        error: function(){
            alert("Fail to get card data");
        }
    });
}

// Helper function for generating all group cards
function generateAllCards(cardData) {
    // get the card results container
    let card_container = $("#card-results");
    // empty the container
    card_container.empty();
    if (Object.keys(cardData).length === 0) {
        let card_empty_text = $("<h5 class=\"card-title\"></h5>");
        card_empty_text.text("No card. Add card to this group.");
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
            let card_text = $("<p class=\"card-text\">")
            let card_link = $("<a class=\"btn btn-inverse-secondary card-details-btn\" data-toggle=\"modal\" data-target=\"#cardViewModal\" >See detail</a>")
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

// generate pagination based on the page info
function generatePagination(pageData, offset) {
    $('.pagination-cards').bootpag({
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

// Member Tab js
$('.invite-check').change(function(){
    let select = $("#invite-username");
    if( $(this).val() == '0')
        select.attr('disabled' , false );
    else
        select.attr('disabled' , true );
})

function generate_invite() {
    let gid = $("#gid").val()
    let status = $("input[name='code-status']:checked").val()
    let username = $("#invite-username").val()
    let date = $("input[name='expiration_date']:checked").val()
    let btn = $("#generate-invite-btn")
    btn.attr('disabled', true);

    $.get("/group/" + gid + "/invite?username=" + username + "&status=" + status + "&date=" + date, function(data) {
        btn.attr('disabled', false);
        if (data['success']) {
            $('#invite-qrcode').html("")
            $("#code-place").val(data['url']);
            new QRCode(document.getElementById('invite-qrcode'), {
                text: data['url'],
                colorDark : "#000000",
                colorLight : "#ffffff",
                correctLevel : QRCode.CorrectLevel.H
            });
        } else {
            show_notice_with_text(data['msg']);
        }
    });
}

function removeMember(member_uid) {
    const gid = $('#gid').val();
    const operator = $('#uid').val();
    $.ajax ({
        url:"/group/" + gid + "/remove_user?operator=" + operator + "&uid=" + member_uid,
        type:"GET",
        success: function(data) {
            show_notice_with_text(data['msg']);
            if (data['success']) {
                let path = '/group/' + gid + '?tab=members';
                let command = "window.location.href='" + path + "'";
                setTimeout(command, 2000);
            }
        },
        error: function(){
            show_notice_with_text("Fail to remove this member");
        }
    });
}

function assignRole(uid, role) {
    const gid = $('#gid').val();
    const operator = $('#uid').val();
    $.ajax ({
        url:"/group/" + gid + "/update_role",
        type:"POST",
        data: {
            'uid': uid,
            'operator': operator,
            'role': role
        },
        success: function(data) {
            show_notice_with_text(data['msg']);
            if (data['success']) {
                let path = '/group/' + gid + '?tab=members';
                let command = "window.location.href='" + path + "'";
                setTimeout(command, 2000);
            }
        },
        error: function(){
            show_notice_with_text("Fail to remove this member");
        }
    });
}


function deleteGroupCard(permission) {
    $("#delete-body").empty();
    $("#delete-buttons-container").empty();
    let close_btn = $('<button type="button" class="btn btn-secondary" id="close-delete-card-btn" data-dismiss="modal">Close</button>');
    $("#delete-buttons-container").append(close_btn);


    if (permission == 1){
        $("#delete-body").text("Are you sure you want to delete this card from this group?");
        let confirm_btn = '<button type="button" class="btn btn-danger" id="delete-card-btn" onclick="deleteCardFromGroup()">Yes</button>';
        $("#delete-buttons-container").append(confirm_btn);
    } else {
        $("#delete-body").text("Sorry, you don't have the permission to delete this card.");
    }
}

function deleteCardFromGroup(){
    $.ajax ({
        url:"card/delete?gid=" + $("#gid").val() + "&cid=" + $("#delete-card-cid").val(),
        type:"GET",
        success: function(data) {
            // @TODO add successfully delete the card message and close the modal
            if(data["success"]) {
                // close the modal
                $('#close-delete-card-btn').click();
                $('#close-card-detail-btn').click();
                show_notice_with_text("Successfully delete the card");
                // rerender all cards based on page
                setTimeout(generateCardsBasedOnPage($(".active-page").text()), 1500);
            }else {
                alert("Fail to delete the card. Please try again.");
            }

        },
        error: function(){
            alert("Fail to delete the card");
        }
    });
}

function copyCardFromGroup() {
    $.ajax ({
        url:"/card/copy?uid=" + $("#uid").val() + "&cid=" + $("#delete-card-cid").val(),
        type:"GET",
        success: function(data) {
            // @TODO add successfully delete the card message and close the modal
            if(data["success"]) {
                // close the modal
                $('#close-copy-card-btn').click();
                $('#close-card-detail-btn').click();
                show_notice_with_text("Successfully copy the card");
                // rerender all cards based on page
                setTimeout(generateCardsBasedOnPage($(".active-page").text()), 1500);
            }else {
                alert("Fail to copy the card. Please try again.");
            }

        },
        error: function(){
            alert("Fail to delete the card");
        }
    });
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