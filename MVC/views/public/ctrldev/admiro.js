function irParaCadastroPlanta() {
    window.location.href = "CadastroPlanta.ejs";
}
function irParaCadastroVenda() {
    window.location.href = "CadastroVenda.ejs";
}
function irParaCadastroUser() {
    window.location.href = "CadastroUser.ejs";
}
function irParaVisaoGeral() {
    window.location.href = "VisaoGeral.ejs";
}
function irParaHomeAdmiro() {
    window.location.href = "Admiro.ejs";
}
function DetalheProduto() {
    window.location.href = "Detalhe.ejs";
}
function AparecerDropdown(){
        const magiva = document.querySelector('.conteudo');
        conteudo.style.display = conteudo.style.display === 'block' ? 'none' : 'block';
}
function TomaOFecho() {
    document.querySelector('.conteudo').style.display = 'none';
}