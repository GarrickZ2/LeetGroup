function createCard() {
    alert("test create card function");
    // get fields from the form and post request
    // validate the form information
    // var form_data = $('#cardForm').serialize();

    // $.ajax({
    //     type: "POST",
    //     url: "",
    //     data: form_data,
    //     success: function(msg){
    //         alert(msg);
    //     },
    //     error: function(){
    //         alert("Failure");
    //     }
    // });
}

function generateAllCards() {
    let card_container = $("#all-cards-container")
    // empty the container
    card_container.empty()

    // generate the card from data
    $.each(data, function(i, datum) {
        let card_div = $("<div class=\"card\">")
        card_container.append(card_div)
        let card_body = $("<div class=\"card-body\">")
        let card_title = $(" <h5 class=\"card-title\"></h5>")
        let card_text = $("<p class=\"card-text\">")
        let card_link = $("<a class=\"btn btn-outline-primary\">See detail</a>")

        let title = $("<br><a>" + datum["title"] + "</a>")
        let new_url = "/main/card/" + datum["id"]
        name.attr("href", new_url)

        // card body
        card_title.text(datum["title"])
        card_text.text(datum["description"])
        card_link.attr("href", new_url)
        card_body.append(card_title)
        card_body.append(card_text)
        card_body.append(card_link)
        card_div.append(card_body)

    })
}
