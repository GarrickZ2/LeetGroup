$( document ).ready(function() {
    // generate group cards tab and pagination
    generateCardsBasedOnPage(1);
    $('.pagination-cards').bootpag({
    }).on("page", function(event, num) {
        generateCardsBasedOnPage(num);
    });

    // @TODO generate members tab and pagination
    // generateMembersBasedOnPage(1);
    // $('.pagination-members').bootpag({
    // }).on("page", function(event, num) {
    //     generateMembersBasedOnPage(num);
    // });


    // @TODO generate setting tab

});

// change role (owner) ; remove(group owner / manager) ; view profile
function generateMembersBasedOnPage(offset) {
    let pagination_data = {
        "size": 6,
        "page": offset
    };
    $.ajax ({
        url:"/group//users",
        type:"POST",
        data: pagination_data,
        success: function(data) {
           // generate all members for this page
            let memberData=data[""];
            generateAllMembers(memberData);
        },
        error: function(){
            alert("Fail to get group members data");
        }
    });
}

function generateAllMembers(memberData) {
    // get the card results container
    let member_container = $("#group-member-container");
    // empty the container
    member_container.empty();
    $.each(memberData, function(i, data) {
        let datum = JSON.parse(data);
        // initialize card
        let card_col = $("<div class=\"col\">")
        let card_div = $("<div class=\"card h-100\">")
        member_container.append(card_col)
        card_col.append(card_div)
        // image/avatar
        let img = $("<img class=\"card-img-top\" alt=\"member avatar\">");
        card_div.append(img);
        // username
        let card_body = $("<div class=\"card-body\">");
        let member_username = $("<p class=\"card-title group-members-name\">");
        card_body.append(member_username);
        // role
        let member_role = $("<p class=\"card-text group-members-role\">");
        card_body.append(member_role);
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
        url:"card/view",
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