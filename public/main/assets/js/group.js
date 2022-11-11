$( document ).ready(function() {
    // generate group cards tab and pagination
    generateCardsBasedOnPage(1);
    $('.pagination-cards').bootpag({
    }).on("page", function(event, num) {
        generateCardsBasedOnPage(num);
    });

    // @TODO generate setting tab

});


function createGroup() {
    // get fields from the form and post request
    // alert("test create group");
    let sel = $('input[type=radio]:checked').map(function(_, el) {
        return $(el).val();
    }).get();

    let form_data = {
        "uid": $("#groupUID").val(),
        "name": $("#groupInputName").val(),
        "description": $("#groupInputDescription").val(),
        "status": sel
    };
    console.log("form data for create group is: " + JSON.stringify(form_data));

    $.ajax({
        type: "POST",
        url: "/group/new",
        data: form_data,
        success: function(msg) {
            if (msg['success']) {
                $("#create-group-notice").text('Successfully creat card')
                setTimeout("$('#new-group-btn').click()", 2000)
                setTimeout("$(':input','#groupForm').val('')", 2000)
                setTimeout("window.location.href = '/main/dashboard'", 2000)
            }else {
                $("#create-group-notice").text(msg['msg']);
            }
        },
        error: function(){
            alert("Fail to create the card. Please try again.");
        }
    });
}

// function to generate all cards
function generateCardsBasedOnPage(offset) {
    let uid = $("#uid").val();
    // @TODO need to change to get group cards
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
    // @TODO need to change to get group cards
    $.ajax ({
        url:"/card/view",
        type:"POST",
        data: pagination_data,
        success: function(data) {
            cardData = data["card_info"];
            pageData = data["page_info"];
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

// Helper function to generate group cards pagination based on the page info
function generateCardPagination(pageData, offset) {
    $('.pagination-cards').bootpag({
        total: pageData["total_page"],
        page: offset,
        maxVisible: 5,
        leaps: true,
    });
    // add class style for pagination
    $('[data-lp]').addClass('page-item');
    $('.page-item > a').addClass('page-link');
}

function joinGroup() {
    const uid = $('#cardUID').val();
    const link = $('#invite-code').val();
    const part = link.split('/');
    const code = part[part.length-1];
    $.get(
        '/group/join/' + code + "?uid=" + uid,
        function (data) {
            show_notice_with_text(data['msg']);
            if (data['success']) {
                setTimeout("window.location.href = '/main/dashboard'", 2000);
            }
        }
    )
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
    const gid = $('#gid').val()
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