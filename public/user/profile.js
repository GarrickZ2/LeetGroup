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
    $(".profile-header-title-detail").attr("hidden", true);
    $(".profile-header-title-avatar").removeAttr("hidden");

}

function hideAvatarPanel() {
    $("#avatar-panel").attr("hidden", true);
    $("#profile-edit-form").removeAttr("hidden");
    $(".profile-header-title-detail").removeAttr("hidden");
    $(".profile-header-title-avatar").attr("hidden", true);
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