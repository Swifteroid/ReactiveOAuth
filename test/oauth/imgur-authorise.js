(function () {
    var form;

    if ((form = document.querySelector("form[method='post']")) != null) {
        form.querySelector("input[name=username]").value = "$(EMAIL)";
        form.querySelector("input[name=password]").value = "$(PASSWORD)";

        setTimeout(function () {
            form.querySelector("button#allow").click();
        }, 500);
    }

    return form != null
        ? "Submitting form: " + form.action
        : "Don't recognise page: " + document.title;
})();