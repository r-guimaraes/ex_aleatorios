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

    $("#valor").html("Kgs necessários: " + Churrasco.total_kg());

    return false;
}