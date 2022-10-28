$("#cardForm").submit(function(e) {
    e.preventDefault();
});

function createCard() {
    // get fields from the form and post request
    // alert("test create card");

    let form_data = {
        "uid": $("#cardUID").val(),
        "title": $("#cardInputTitle").val(),
        "source": $("#cardInputSource").val(),
        "description": $("#cardInputDescription").val()
    };
    // console.log("form data for create card is: " + JSON.stringify(form_data));

    $.ajax({
        type: "POST",
        url: "card/new",
        data: form_data,
        success: function(msg){
            console.log("ajax success");
            alert(msg);
        },
        error: function(){
            alert("Fail to create the card");
        }
    });
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
