var Churrasco = new function () {
    this.adultos = 0;
    this.criancas = 0;
    this.precos = {
        picanha: 45,
        contra_file: 35,
        fraldinha: 28,
        cupim: 22,
        coracao: 14,
        linguica: 12
    };

    // em Kg
    this.qtd_por_pessoa = {
      adulto: 0.5,
      crianca: 0.2
    };
    this.total_kg = function () {
        return (this.adultos * this.qtd_por_pessoa.adulto) + (this.criancas * this.qtd_por_pessoa.crianca);
    }

};


function totalChurrasco() {
    event.preventDefault();

    Churrasco.adultos = parseInt($('input[name="adultos"]').val());
    Churrasco.criancas = parseInt($('input[name="criancas"]').val());

    var escolhas = [];
    $(':checkbox:checked').each(function(i){
        escolhas[i] = $(this).val();
    });

    var custo = 0;
    $(escolhas).each(function (i,v) {
        custo += Churrasco.precos[v];
    });

    $(".calc-wrapper").removeClass('d-none');

    var quilos = Churrasco.total_kg();
    var qtd = "Quantidade necessária: " + quilos  + " Kgs";
    var preco = "<br> R$ " + ((custo * quilos) / escolhas.length) + "<br>";
    var obs = "<small><i>Considerando quantidades similares de cada corte selecionado</i></small>";

    $("#valor").html( qtd + preco + obs);

    return false;
}