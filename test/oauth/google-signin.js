(function () {
    var element;

    if ((element = document.querySelector("input[name='Email']#Email")) != null && element.value === '') {
        element.value = "$(EMAIL)";
        document.querySelector("input[name='signIn']#next").click();
    } else if ((element = document.querySelector("input[name='Passwd']#Passwd")) != null && element.value === '') {
        element.value = "$(PASSWORD)";
        document.querySelector("input[name='signIn']#signIn").click()
    }

    return element != null
        ? "Element found, interacting…"
        : "Don't recognise page: " + document.title;
})();