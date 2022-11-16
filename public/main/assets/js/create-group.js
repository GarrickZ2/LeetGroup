// for disabling form submissions if there are invalid fields
$("#groupForm").submit(function(e) {
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


function createGroup() {
    // get fields from the form and post request

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
                $("#create-group-notice").text('Successfully create group')
                setTimeout("$('#new-group-btn').click()", 2000)
                setTimeout("$(':input','#groupForm').val('')", 2000)
                setTimeout("window.location.href = '/main/dashboard'", 2000)
            }else {
                $("#create-group-notice").text(msg['msg']);
            }
        },
        error: function(){
            alert("Fail to create the group. Please try again.");
        }
    });
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