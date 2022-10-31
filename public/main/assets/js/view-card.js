// initialize modal
$('#cardViewModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var title = button.data('title') // Extract info from data-* attributes
    var source = button.data('source')
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    var modal = $(this)
    modal.find('.modal-title').text('Card: ' + button.data('title'))
    modal.find('#card-view-source').val(source)
})

// initialize bootpag and generate cards from data
generateCardsBasedOnPage(1);
$('.pagination-here').bootpag({
}).on("page", function(event, num) {
    generateCardsBasedOnPage(num);
});

// function to generate all cards
function generateCardsBasedOnPage(offset) {
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

// generate pagination based on the page info
function generatePagination(pageData, offset) {
    $('.pagination-here').bootpag({
        total: pageData["total_page"],
        page: offset,
        maxVisible: 5,
        leaps: true,
    });
    // add class style for pagination
    $('[data-lp]').addClass('page-item');
    $('.page-item > a').addClass('page-link');
}


function generateAllCards(cardData) {
    // get the card results container
    let card_container = $("#card-results");
    // empty the container
    card_container.empty();
    $.each(cardData, function(i, data) {
        let datum = JSON.parse(data);
        let card_div = $("<div class=\"card\">")
        card_container.append(card_div)
        let card_body = $("<div class=\"card-body\">")
        let card_title = $(" <h5 class=\"card-title\"></h5>")
        let card_text = $("<p class=\"card-text\">")
        let card_link = $("<a class=\"btn btn-inverse-secondary card-details-btn\" data-toggle=\"modal\" data-target=\"#cardViewModal\">See detail</a>")
        card_link.attr("data-cid", datum["cid"]);
        card_link.attr("data-title", datum["title"]);
        card_link.attr("data-source", datum["source"]);
        card_link.attr("data-description", "test desc");
        card_link.attr("data-star", 3);

        // card body
        card_title.text(datum["title"])
        card_text.text(datum["source"])
        card_body.append(card_title)
        card_body.append(card_text)
        card_body.append(card_link)
        card_div.append(card_body)
    });
}

// star change
function changeStarIcon() {
    let star_icon = $(".star-icon");
    star_icon.removeClass("mdi-star-outline");
    star_icon.addClass("mdi-star");
}
