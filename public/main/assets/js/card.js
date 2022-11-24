
// for disabling form submissions if there are invalid fields
$("#cardForm").submit(function(e) {
    e.preventDefault();
});

(function () {
    'use strict'
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    var forms = document.querySelectorAll('.needs-validation')

    // Loop over them and prevent submission
    Array.prototype.slice.call(forms)
        .forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }

                form.classList.add('was-validated')
            }, false)
        })
})()


function createCard() {
    // get fields from the form and post request
    // alert("test create card");

    let form_data = {
        "uid": $("#cardUID").val(),
        "title": $("#cardInputTitle").val(),
        "source": $("#cardInputSource").val(),
        "description": $("#cardInputDescription").val()
    };

    $.ajax({
        type: "POST",
        url: "/card/new",
        data: form_data,
        success: function(msg) {
            if (msg['success']) {
                $("#create-card-notice").text('Successfully create card')
                setTimeout("$('#new-card-btn').click()", 2000)
                setTimeout("$(':input','#cardForm').val('')", 2000)
            }else {
                $("#create-card-notice").text(msg['msg']);
            }
        },
        error: function(){
            alert("Fail to create the card. Please try again.");
        }
    });
}




