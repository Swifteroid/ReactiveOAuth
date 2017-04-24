(function () {
    var form;

    if ((form = document.querySelector("form[action='/ajax_login']")) != null) {
        form.querySelector("input[name=login_email]").value = "$(EMAIL)";
        form.querySelector("input[name=login_password]").value = "$(PASSWORD)";

        setTimeout(function () {
            form.querySelector("button.login-button.button-primary").click();
        }, 1000);
    } else if ((form = document.querySelector("form[action='/1/oauth2/authorize_submit']")) != null) {
        setTimeout(function () {
            form.querySelector("button.auth-button.button-primary[name=allow_access]").click();
        }, 1000);
    }

    return form != null
        ? "Submitting form: " + form.action
        : "Don't recognise page: " + document.title;
})();