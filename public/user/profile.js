function change_tab(name) {
    $('#avatar-tab').removeClass('active')
    $('#view-tab').removeClass('active')
    $('#edit-tab').removeClass('active')

    let avatar = $('#avatar')
    let view = $('#view')
    let edit = $('#edit')

    avatar.removeClass('active')
    view.removeClass('active')
    edit.removeClass('active')

    avatar.removeClass('fade')
    view.removeClass('fade')
    edit.removeClass('fade')

    if (name === 'avatar') {
        $('#avatar-tab').addClass('active')
        avatar.addClass('active')
        view.addClass('fade')
        edit.addClass('fade')
        $('#save-btn').text('Save Your Avatar')
    } else if (name === 'view') {
        $('#view-tab').addClass('active')
        view.addClass('active')
        avatar.addClass('fade')
        edit.addClass('fade')
        $('#save-btn').text('View Your Profile')
    } else if (name === 'edit') {
        $('#edit-tab').addClass('active')
        edit.addClass('active')
        view.addClass('fade')
        avatar.addClass('fade')
        $('#save-btn').text('Save Your Profile')
    }
}

function submit() {
    const save_type = $('#save-btn').text()
    if (save_type === 'Save Your Profile') {
        $('#profile-edit').submit()
    } else if (save_type === 'Save Your Avatar') {
        $('#save_avatar').submit()
    }
}

$('.select-avatar li').click(function () {
    $(".select-avatar li").removeClass("selected");
    $(this).toggleClass('selected');
    $('#avatar-index').val($(this).attr('value'))
});