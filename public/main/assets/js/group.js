$(document).ready(function () {
    // generate group overview
    generateGroupOverview();

    // generate group cards tab and pagination
    generateCardsBasedOnPage(1);
    $('.pagination-cards').bootpag({}).on("page", function (event, num) {
        generateCardsBasedOnPage(num);
    });

    $('#cardViewModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget) // Button that triggered the modal
        var cid = button.data('cid') // Extract info from data-* attributes
        // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
        var cardDetail = [];
        $.ajax({
            url: "/group/" + $("#gid").val() + "/card_detail/" + cid,
            type: "GET",
            success: function (data) {
                cardDetail = Object.values(data)[0];
                putCardDetail(cardDetail, cid);
            },
            error: function () {
                alert("Fail to get card details");
            }
        });
    });

    $('#deleteGroupCardModal').on('show.bs.modal', function (event) {
        let uid = $("#uid").val();
        // // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
        let permission = 0;
        $.ajax({
            url: $("#gid").val() + "/check_permission/" + uid + "/" + $('#delete-card-cid').val(),
            type: "GET",
            success: function (data) {
                permission = data["result"];
                deleteGroupCard(permission);
            },
            error: function () {
                alert("Fail to get group details");
            }
        });
    });
    $('#card-view-comment').focus(function (event) {
        $('#card-view-comment').addClass('card-view-comment-focus');
        $('#comment-save-btn').css('visibility', 'visible');
    });

    $('#card-view-comment').blur(function (event) {
        if ($('#card-view-comment').val().length === 0) {
            $('#card-view-comment').removeClass('card-view-comment-focus');
            $('#comment-save-btn').css('visibility', 'hidden');
        }
    });


    $('#delete-group-btn').attr('href', "/group/" + $("#gid").val() + "/destroy?uid=" + $("#uid").val());
});


function generateGroupOverview() {
    let gid = $("#gid").val();
    $.ajax({
        url: "/group/overview/" + gid,
        type: "GET",
        success: function (data) {
            console.log("group overview data", data["group_info"]);
            let group_info = data["group_info"];
            let owner_info = data["owner_info"];
            $('#group-overview-name').text(group_info["name"]);
            $('#group-overview-status').text(group_info["status"]);
            $('#group-overview-description').text(group_info["description"]);
            $('#group-overview-owner').text(owner_info["username"]);
            let total_cards = data["total_cards"];
            let total_users = data["total_users"];
            let card_text = "";
            let member_text = "";
            if (total_cards <= 1) {
                card_text = total_cards + " card";
            } else {
                card_text = total_cards + " cards";
            }

            if (total_users <= 1) {
                member_text = total_users + " member";
            } else {
                member_text = total_users + " members";
            }

            $('#group-overview-cards').text(card_text);
            $('#group-overview-members').text(member_text);
            $('#nav-home').attr('hidden', false);
            $('#group-overview-spinner').attr('hidden', true);
        },
        error: function () {
            alert("Fail to delete the card");
        }
    });
}

function clickCardsBtn() {
    $('#nav-group-cards-tab').click();
}

function clickMemberBtn() {
    $('#nav-members-tab').click();
}

function putCardDetail(cardDetail, cid) {
    $('#card-view-title').val(cardDetail["title"]);
    $('#card-view-description').text(cardDetail["description"]);
    $('#card-view-source').val(cardDetail["source"]);
    $('#card-view-create-time').text(processDate(cardDetail["create_time"]));
    $('#card-view-star').text("Star " + cardDetail["stars"]);
    $('#card-view-used-time').text(processUsedTime(cardDetail["used_time"]));
    $('#delete-card-cid').val(cid);
    $.get({
        url: '/card/comment/show?cid=' + cid,
        success: function (data) {
            const commentData = data["comments"];
            $.each(commentData, function (i, comment) {
                comment = JSON.parse(comment);
                appendComment(comment['avatar'], comment['content']);
            });
        }
    })
}

function appendComment(avatar, content) {
    const layout = $('<div class="row card-single-comment-container">' +
        '<div class="col-md-2 col-sm-2 card-comment-avatar-container">' +
        '<img class="img-xs rounded-circle" src="' + avatar + '" alt="avatar">' +
        '</div>' +
        '<div class="col-md-10 col-sm-10 card-comment-container"><span>' +
        content +
        '</span></div>' +
        '</div>');
    $('#comment-area').prepend(layout);
}

function sendComment() {
    const content = $("#card-view-comment").val();
    let form_data = {
        "uid": $("#uid").val(),
        "cid": $("#delete-card-cid").val(),
        "content": content
    };
    $.post({
        url: '/card/comment/new',
        data: form_data,
        success: function (msg) {
            show_notice_with_text(msg['msg']);
            if (msg['success']) {
                appendComment($("#comment-img-path").attr("src"), content);
            }
            $("card-view-comment").val("");
        }
    });
}

// function to generate all cards
function generateCardsBasedOnPage(offset) {
    let gid = $("#gid").val();
    let pagination_data = {
        "status": 3,
        "page_size": 6,
        "offset": offset - 1,
        "sort_by": "create_time",
        "sort_type": "asc"
    };
    // get card info and page info data
    var cardData = [];
    var pageData = [];
    // @TODO need to change to get group cards
    $.ajax({
        url: "/group/" + gid + "/cards",
        type: "POST",
        data: pagination_data,
        success: function (data) {
            cardData = data["card_info"];
            pageData = data["page_info"];
            generateAllCards(cardData);
            generatePagination(JSON.parse(pageData), offset);
        },
        error: function () {
            alert("Fail to get card data");
        }
    });
}

// Helper function for generating all group cards
function generateAllCards(cardData) {
    // get the card results container
    let card_container = $("#card-results");
    // empty the container
    card_container.empty();
    if (Object.keys(cardData).length === 0) {
        let card_empty_text = $("<h5 class=\"card-title\"></h5>");
        card_empty_text.text("No card. Add card to this group.");
        card_container.append(card_empty_text);
    } else {
        $.each(cardData, function (i, data) {
            let datum = JSON.parse(data);
            let card_col = $("<div class=\"col\">")
            let card_div = $("<div class=\"card\">")
            card_container.append(card_col)
            card_col.append(card_div)
            let card_body = $("<div class=\"card-body\">")
            let card_title = $("<h5 class=\"card-title\"></h5>")
            let card_text = $("<p class=\"card-text\">")
            let card_link = $("<a class=\"btn btn-inverse-secondary card-details-btn\" data-toggle=\"modal\" data-target=\"#cardViewModal\" >See detail</a>")
            card_link.attr("data-cid", datum["cid"]);
            card_link.attr("id", "card-detail-btn-" + datum["cid"]);

            // card body
            card_title.text(datum["title"])
            card_text.text(datum["source"])
            card_body.append(card_title)
            card_body.append(card_text)
            card_body.append(card_link)
            card_div.append(card_body)
        });
    }
}

// generate pagination based on the page info
function generatePagination(pageData, offset) {
    $('.pagination-cards').bootpag({
        total: pageData["total_page"],
        page: offset,
        maxVisible: 5,
        leaps: true,
        activeClass: "active-page"
    });
    // add class style for pagination
    $('[data-lp]').addClass('page-item');
    $('.page-item > a').addClass('page-link');
}

// Member Tab js
$('.invite-check').change(function () {
    let select = $("#invite-username");
    if ($(this).val() == '0')
        select.attr('disabled', false);
    else
        select.attr('disabled', true);
})

function generate_invite() {
    let gid = $("#gid").val()
    let status = $("input[name='code-status']:checked").val()
    let username = $("#invite-username").val()
    let date = $("input[name='expiration_date']:checked").val()
    let btn = $("#generate-invite-btn")
    btn.attr('disabled', true);

    $.get("/group/" + gid + "/invite?username=" + username + "&status=" + status + "&date=" + date, function (data) {
        btn.attr('disabled', false);
        if (data['success']) {
            $('#invite-qrcode').html("")
            $("#code-place").val(data['url']);
            new QRCode(document.getElementById('invite-qrcode'), {
                text: data['url'],
                colorDark: "#000000",
                colorLight: "#ffffff",
                correctLevel: QRCode.CorrectLevel.H
            });
        } else {
            show_notice_with_text(data['msg']);
        }
    });
}

function removeMember(member_uid) {
    const gid = $('#gid').val();
    const operator = $('#uid').val();
    $.ajax({
        url: "/group/" + gid + "/remove_user?operator=" + operator + "&uid=" + member_uid,
        type: "GET",
        success: function (data) {
            show_notice_with_text(data['msg']);
            if (data['success']) {
                let path = '/group/' + gid + '?tab=members';
                let command = "window.location.href='" + path + "'";
                setTimeout(command, 2000);
            }
        },
        error: function () {
            show_notice_with_text("Fail to remove this member");
        }
    });
}

function assignRole(uid, role) {
    const gid = $('#gid').val();
    const operator = $('#uid').val();
    $.ajax({
        url: "/group/" + gid + "/update_role",
        type: "POST",
        data: {
            'uid': uid,
            'operator': operator,
            'role': role
        },
        success: function (data) {
            show_notice_with_text(data['msg']);
            if (data['success']) {
                let path = '/group/' + gid + '?tab=members';
                let command = "window.location.href='" + path + "'";
                setTimeout(command, 2000);
            }
        },
        error: function () {
            show_notice_with_text("Fail to remove this member");
        }
    });
}


function deleteGroupCard(permission) {
    $("#delete-body").empty();
    $("#delete-buttons-container").empty();
    let close_btn = $('<button type="button" class="btn btn-secondary" id="close-delete-card-btn" data-dismiss="modal">Close</button>');
    $("#delete-buttons-container").append(close_btn);


    if (permission == 1) {
        $("#delete-body").text("Are you sure you want to delete this card from this group?");
        let confirm_btn = '<button type="button" class="btn btn-danger" id="delete-card-btn" onclick="deleteCardFromGroup()">Yes</button>';
        $("#delete-buttons-container").append(confirm_btn);
    } else {
        $("#delete-body").text("Sorry, you don't have the permission to delete this card.");
    }
}

function deleteCardFromGroup() {
    $.ajax({
        url: "card/delete?gid=" + $("#gid").val() + "&cid=" + $("#delete-card-cid").val(),
        type: "GET",
        success: function (data) {
            // @TODO add successfully delete the card message and close the modal
            if (data["success"]) {
                // close the modal
                $('#close-delete-card-btn').click();
                $('#close-card-detail-btn').click();
                show_notice_with_text("Successfully delete the card");
                // rerender all cards based on page
                setTimeout(generateCardsBasedOnPage($(".active-page").text()), 1500);
            } else {
                alert("Fail to delete the card. Please try again.");
            }

        },
        error: function () {
            alert("Fail to delete the card");
        }
    });
}

function copyCardFromGroup() {
    $.ajax({
        url: "/card/copy?uid=" + $("#uid").val() + "&cid=" + $("#delete-card-cid").val(),
        type: "GET",
        success: function (data) {
            // @TODO add successfully delete the card message and close the modal
            if (data["success"]) {
                // close the modal
                $('#close-copy-card-btn').click();
                $('#close-card-detail-btn').click();
                show_notice_with_text("Successfully copy the card");
                // rerender all cards based on page
                setTimeout(generateCardsBasedOnPage($(".active-page").text()), 1500);
            } else {
                alert("Fail to copy the card. Please try again.");
            }

        },
        error: function () {
            alert("Fail to delete the card");
        }
    });
}

// helper function
function processDate(date) {
    return new Date(Date.parse(date)).toLocaleString()
}

// helper function
function processUsedTime(totalSeconds) {
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;

    function padTo2Digits(num) {
        return num.toString().padStart(2, '0');
    }

    // format as MM:SS
    const result = `${padTo2Digits(minutes)}:${padTo2Digits(seconds)}`;
    return result;
}

function changeStarIcon() {
    let data = {
        "uid": $("#uid").val(),
        "cid": $("#delete-card-cid").val()
    }
    $.ajax({
        url: "card/addStar",
        type: "POST",
        data: data,
        success: function (data) {
            if (data["success"]) {
                let star_icon = $(".star-icon");
                star_icon.removeClass("mdi-star-outline");
                star_icon.addClass("mdi-star");
                setTimeout(function () {
                    star_icon.removeClass("mdi-star");
                    star_icon.addClass("mdi-star-outline");
                }, 300);
                $('#card-view-star').text("Star " + data["star_number"]);
            }
        },
        error: function () {
            alert("Fail to add star to the card");
        }
    });

}
