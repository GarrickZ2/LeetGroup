// create fake json to test cards rendering
let card_data = {
    "card_info": [
        {
            "cid": 1,
            "title": "card1",
            "source": "source1"
        },
        {
            "cid": 2,
            "title": "card2",
            "source": "source2"
        },
        {
            "cid": 3,
            "title": "card3",
            "source": "source3"
        },
        {
            "cid": 4,
            "title": "card4",
            "source": "source4"
        }
    ],
    "page_info": {
        "total_page": 10,
        "total_size": 20,
        "current_page": 1,
        "current_size": 1,
    }
}

let card_data2 = {
    "card_info": [
        {
            "cid": 1,
            "title": "card11",
            "source": "source11"
        },
        {
            "cid": 2,
            "title": "card21",
            "source": "source21"
        },
        {
            "cid": 3,
            "title": "card31",
            "source": "source31"
        },
        {
            "cid": 4,
            "title": "card41",
            "source": "source31"
        }
    ],
    "page_info": {
        "total_page": 10,
        "total_size": 20,
        "current_page": 1,
        "current_size": 1,
    }
}


// all cards js
// modal function
$('#cardViewModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var title = button.data('title') // Extract info from data-* attributes
    var source = button.data('source')
    // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    var modal = $(this)
    modal.find('.modal-title').text('Card' + button.data('cid'))
    modal.find('#card-view-source').val(source)
})

// init bootpag and generate cards from data
generateCardsBasedOnPage(1);
$('.pagination-here').bootpag({
    total: 10,
    page: 1,
    maxVisible: 5,
    leaps: true,
}).on("page", function(event, num) {
    generateCardsBasedOnPage(num);
});

// add class style for pagination
$('[data-lp]').addClass('page-item');
$('.page-item > a').addClass('page-link');


function generateCardsBasedOnPage(offset) {
    // get the card results container
    let card_container = $("#card-results")
    // empty the container
    card_container.empty()

    let card_uid = $("#card-uid").val();
    let pagination_data = {
        "uid": card_uid,
        "status": 3 ,
        "page_size": 9,
        "offset": offset,
        "sort_by": "create_time",
        "sort_type": 0
    };
    console.log("Pagination data is : " + JSON.stringify(pagination_data));
    // //get data
    // $.ajax ({
    //     url:"/card/view",
    //     type:"POST",
    //     success: function(data) {
    //         let cardData = data["card_info"];
    //     },
    //     error: function(){
    //         alert("Fail to get card data");
    //     }
    // });
    var data = [];
    if(offset === 1) {
        data = card_data["card_info"];
    }else {
        data = card_data2["card_info"];
    }
    $.each(data, function(i, datum) {
        let card_div = $("<div class=\"card\">")
        card_container.append(card_div)
        let card_body = $("<div class=\"card-body\">")
        let card_title = $(" <h5 class=\"card-title\"></h5>")
        let card_text = $("<p class=\"card-text\">")
        let card_link = $("<a class=\"btn btn-inverse-secondary card-details-btn\" data-toggle=\"modal\" data-target=\"#cardViewModal\">See detail</a>")
        let card_uid = $("<input id=\"card-uid\" type=\"hidden\" value=\"<%#= session[:uid] %>\">")
        card_link.attr("data-cid", datum["cid"]);
        card_link.attr("data-title", datum["title"]);
        card_link.attr("data-source", datum["source"]);
        card_link.attr("data-description", "test desc");
        card_link.attr("data-star", 3);

        // card body
        card_title.text(datum["title"])
        card_text.text("test")
        card_body.append(card_title)
        card_body.append(card_text)
        card_body.append(card_link)
        card_div.append(card_body)
        card_div.append(card_uid)
    });
}

// star change
function changeStarIcon() {
    let star_icon = $(".star-icon");
    star_icon.removeClass("mdi-star-outline");
    star_icon.addClass("mdi-star");
}
