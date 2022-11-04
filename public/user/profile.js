function change_tab(name) {
    $('#avatar-tab').removeClass('active')
    // $('#view-tab').removeClass('active')
    // $('#edit-tab').removeClass('active')

    let avatar = $('#avatar')
    // let view = $('#view')
    // let edit = $('#edit')

    avatar.removeClass('active')
    // view.removeClass('active')
    // edit.removeClass('active')

    avatar.removeClass('fade')
    // view.removeClass('fade')
    // edit.removeClass('fade')

    if (name === 'avatar') {
        $('#avatar-tab').addClass('active')
        avatar.addClass('active')
        // view.addClass('fade')
        // edit.addClass('fade')
        $('#save-btn').text('Save Your Avatar')
    }
    // } else if (name === 'view') {
    //     $('#view-tab').addClass('active')
    //     view.addClass('active')
    //     avatar.addClass('fade')
    //     edit.addClass('fade')
    //     $('#save-btn').text('View Your Profile')
    // } else if (name === 'edit') {
    //     $('#edit-tab').addClass('active')
    //     edit.addClass('active')
    //     view.addClass('fade')
    //     avatar.addClass('fade')
    //     $('#save-btn').text('Save Your Profile')
    // }
}

function editProfile(name) {
    let role =  $("#inputRole");
    let school = $("#inputSchool");
    let company = $("#inputCompany");
    let city =  $("#inputCity");
    let bio = $("#inputBio");
    let btn =  $(".profile-edit-btn");
    if (name === 'edit') {
        // remove readonly attr
        role.removeAttr("readonly");
        school.removeAttr("readonly");
        company.removeAttr("readonly");
        city.removeAttr("readonly");
        bio.removeAttr("readonly");
        // show the button
        btn.removeAttr("hidden");
        // add styles to editable input fields
        role.addClass("edit-mode");
        school.addClass("edit-mode");
        company.addClass("edit-mode");
        city.addClass("edit-mode");
        bio.addClass("edit-mode");
    } else if (name === 'cancel') {
        btn.attr("hidden", true);
        // remove styles to editable input fields
        role.attr("readonly", true);
        school.attr("readonly", true);
        company.attr("readonly", true);
        city.attr("readonly", true);
        bio.attr("readonly", true);
        // remove styles to editable input fields
        role.removeClass("edit-mode");
        school.removeClass("edit-mode");
        company.removeClass("edit-mode");
        city.removeClass("edit-mode");
        bio.removeClass("edit-mode");
    }

}

function showAvatarPanel() {
    $("#profile-edit-form").attr("hidden", true);
    $("#avatar-panel").removeAttr("hidden");
    let title = $(".profile-header-title");
    title.empty();
    title.text("Change your avatar");

}

function hideAvatarPanel() {
    $("#avatar-panel").attr("hidden", true);
    $("#profile-edit-form").removeAttr("hidden");
}

function submitProfileChange() {
    $('#profile-edit-form').submit();
}

function submitAvatarChange() {
    $('#save-avatar').submit();
}

$('.select-avatar li').click(function () {
    $(".select-avatar li").removeClass("selected");
    $(this).toggleClass('selected');
    $('#avatar-index').val($(this).attr('value'))
});