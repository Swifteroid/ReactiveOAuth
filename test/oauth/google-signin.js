(function () {
    var form;
    var element;

    if ((form = document.querySelector("form#gaia_loginform")) != null) {
        if ((element = form.querySelector("input[name='Email']#Email")) != null && element.value === '') {
            element.value = "$(EMAIL)";
            form.querySelector("input[name='signIn']#next").click();
        } else if ((element = form.querySelector("input[name='Passwd']#Passwd")) != null && element.value === '') {
            element.value = "$(PASSWORD)";
            form.querySelector("input[name='signIn']#signIn").click()
        }
    }

    return element != null
        ? "Element found, interacting…"
        : "Don't recognise page: " + document.title;
})();