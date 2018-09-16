var Churrasco = new function () {
    this.adultos = 0;
    this.criancas = 0;
    this.custo_total = 0;
    this.precos = {
        picanha: 45,
        contra_file: 35,
        fraldinha: 28,
        cupim: 22,
        coracao: 14,
        linguica: 12
    };
    this.qtd_por_pessoa = { // em Kg
      adulto: 0.5,
      crianca: 0.2
    };

    this.total_kg = function () {
        return (this.adultos * this.qtd_por_pessoa.adulto) + (this.criancas * this.qtd_por_pessoa.crianca);
    };

    this.calcula_custo = function (cortes) {
        var custo = 0;
        $(cortes).each(function (i,v) {
            custo += Churrasco.precos[v];
        });
        var quilos = Churrasco.total_kg();

        return ((custo * quilos) / cortes.length);
    }
};

function totalChurrasco() {
    event.preventDefault();

    Churrasco.adultos = parseInt($('input[name="adultos"]').val());
    Churrasco.criancas = parseInt($('input[name="criancas"]').val());

    var escolhas = pegarCortes();
    var _preco = Churrasco.calcula_custo(escolhas);
    var kg = Churrasco.total_kg();

    $(".calc-wrapper").removeClass('d-none').addClass('result');
    $("#valor").html(retorno(kg, _preco));

    return false;
}

function retorno(kg, preco) {
    var reais = preco.toFixed(2);
    var num_adultos = Churrasco.adultos;
    var r = "<hr> Quantidade recomendada: " + kg.toFixed(2)  + " Kgs";
    r += "<br> Estimativa de preço: R$ " + reais;
    r += "<br> Valor estimado por adulto: R$ " + (reais/num_adultos).toFixed(2) + "<br><br>";
    r += "<small><i>Considerando quantidades similares de cada corte selecionado</i></small>";

    return r;
}

function pegarCortes() {
    var cortes = [];
    $(':checkbox:checked').each(function(i){
        cortes[i] = $(this).val();
    });

    return cortes;
}