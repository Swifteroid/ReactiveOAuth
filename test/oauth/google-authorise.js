(function () {
    var form;

    if ((form = document.querySelector("form[action^='https://accounts.google.com/o/oauth2/approval']")) != null) {
        setTimeout(function () {
            form.querySelector("button#submit_approve_access").click()
        }, 1000);
    }

    return form != null
        ? "Submitting form: " + form.action
        : "Don't recognise page: " + document.title;
})();