<html>
<head>
	<meta charset="utf-8"/>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.js" integrity="sha512-+k1pnlgt4F1H8L7t3z95o3/KO+o78INEcXTbnoJQ/F2VqDVhWoaiVml/OEHv9HsVgxUaVW+IbiZPUJQfF/YxZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<title>Haro Sushi</title>
	<style>
body {
    font-family: Arial, sans-serif;
    background-color: #e5e5e5;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
    min-height: 100vh;
    color: #333;
    position: relative;
}

.login-buttons {
    position: absolute;
    top: 10px;
    left: 10px;
    display: flex;
    gap: 10px;
}

a {
    display: inline-block;
    padding: 10px 20px;
    font-size: 14px;
    font-weight: bold;
    text-decoration: none;
    color: #fff;
    background-color: #ff416c;
    border-radius: 5px;
    transition: background-color 0.3s ease;
}

a:hover {
    background-color: #d83a5d;
}

#imoveis {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    width: 90%;
    max-width: 1200px;
    margin-top: 80px; /* Ajuste a margem superior para descer os itens */
}

.imovel-card {
    background-color: #fff;
    border-radius: 5px;
    padding: 15px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    border: 1px solid #e5e5e5;
    text-align: center;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.imovel-card:hover {
    transform: scale(1.05);
    box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2);
}

.imovel-card img {
    width: 100%;
    height: 150px;
    object-fit: cover;
    border-radius: 5px;
    margin-bottom: 10px;
}

.imovel-info {
    color: #333;
    font-size: 14px;
}

.imovel-info p {
    margin: 5px 0;
    font-weight: bold;
}

.imovel-info span {
    color: #ff416c;
}
	</style>
</head>
<body>
    <div class="login-buttons">
        <a href="PageLogin.jsp">Fazer Login Funcionário</a>
        <a href="PageLoginCliente.jsp">Fazer Login Cliente</a>
    </div>
    
    <div id="imoveis"></div>

    <script>
        function consultar() {
            var jsonEnvio = { acao: "consultar" };
            
            $.ajax({
                url: "ImovelServlet",
                data: jsonEnvio,
                type: "post",
                success: function (resp) {
                    var jsonVetor = JSON.parse(resp);
                    var linhas = "";
                    
                    for (var i = 0; i < jsonVetor.length; i++) {
                        var codigo = jsonVetor[i].codigo;
                        var foto = jsonVetor[i].foto;
                        var tipo = jsonVetor[i].tipo;
                        var valor = jsonVetor[i].valor;
                
                        linhas += `
                            <div class="imovel-card">
                                <img src="` + foto + `" alt="Imagem do imóvel ` + codigo + `">
                                <div class="imovel-info">
                                    <p>Tipo de Imóvel: <span>` + tipo + `</span></p>
                                    <p>Valor: R$ <span>` + valor + `</span></p>
                                </div>
                            </div>
                        `;
                    }

                    document.getElementById("imoveis").innerHTML = linhas;
                },
                error: function () {
                    alert("Ocorreu um erro ao consultar os imóveis!");
                }
            });
        }
        
        consultar();
    </script>
</body>

</html>