function totalChurrasco() {
    var adults = parseInt($('input[name="adultos"]').val());
    var children = parseInt($('input[name="criancas"]').val());
    var total = adults + children;
    alert("churrasco pra " + total + " pessoas");
}

var $forn = {
  picanha: 30,
  fraldinha: 20,
  cupim: 22,
};

function valores() {
    return $forn.cupim;
}