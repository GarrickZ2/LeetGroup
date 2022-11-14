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