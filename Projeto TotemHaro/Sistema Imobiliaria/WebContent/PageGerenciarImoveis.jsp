<%@ include file="ProtecaoFuncionario.jsp" %>

<html>
<head>
	<meta charset="utf-8"/>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.js" integrity="sha512-+k1pnlgt4F1H8L7t3z95o3/KO+o78INEcXTbnoJQ/F2VqDVhWoaiVml/OEHv9HsVgxUaVW+IbiZPUJQfF/YxZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<title>Gerenciar Produtos</title>
	<style>
        /* Estilos para o layout geral */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 900px;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
        }

        a {
            display: inline-block;
            margin-bottom: 10px;
            font-size: 16px;
            color: #007bff;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        /* Estilos para o formulário */
        form {
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
            margin-top: 10px;
            display: block;
        }

        input[type="text"], input[type="file"] {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }

        input[type="button"], input[type="reset"] {
            padding: 10px 15px;
            margin-top: 15px;
            margin-right: 10px;
            font-size: 16px;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        input[type="button"] {
            background-color: #28a745;
        }

        input[type="button"]:hover {
            background-color: #218838;
        }

        input[type="reset"] {
            background-color: #dc3545;
        }

        input[type="reset"]:hover {
            background-color: #c82333;
        }

        #foto {
            max-width: 150px;
            height: 150px;
            border: 1px solid #ddd;
            object-fit: cover;
            margin-top: 10px;
        }

        /* Estilos para a tabela */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #e9ecef;
        }

        img {
            cursor: pointer;
        }

    </style>
</head>
<body>

    <div class="container">
        <a href="PageAreaAdministrativa.jsp">Voltar</a>
        <h2>Gerenciar Imóveis</h2>

        <form>
            <label for="inp">Foto do produto</label><br>
            <img id="foto" alt="Foto do produto">
            <input id="inp" type="file"><br><br>

            <label for="codigo">Código</label>
            <input type="text" id="codigo" disabled><br>

            <label for="tipo">Tipo Produto</label>
            <input type="text" id="tipo"><br>

            <label for="valor">Valor</label>
            <input type="text" id="valor"><br><br>

            <input type="button" value="Buscar" onclick="consultar()">
            <input type="button" value="Salvar" onclick="inserirOuAlterar()">
            <input type="reset" value="Limpar" onclick="limpar()"><br><br>
        </form>

        <table>
            <thead>
                <tr>
                    <th>Editar</th>
                    <th>Excluir</th>
                    <th>Código</th>
                    <th>Tipo</th>
                    <th>Valor (R$)</th>
                </tr>
            </thead>
            <tbody id="corpo_da_tabela"></tbody>
        </table>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function limpar() {
            document.getElementById("foto").src = '';
        }

        function readFile() {
            if (!this.files || !this.files[0]) return;
            const fileReader = new FileReader();
            fileReader.addEventListener("load", function(evt) {
                document.querySelector("#foto").src = evt.target.result;
            });
            fileReader.readAsDataURL(this.files[0]);
        }
        document.querySelector("#inp").addEventListener("change", readFile);

        function editar(codigo, foto, tipo, valor) {
            document.getElementById("codigo").value = codigo;
            document.getElementById("foto").src = foto;
            document.getElementById("tipo").value = tipo;
            document.getElementById("valor").value = valor;
        }

        function confirmarExcluir(codigo) {
            if (confirm("Deseja realmente excluir?")) {
                excluir(codigo);
            }
        }

        function inserirOuAlterar() {
            var jsonEnvio = {
                codigo: document.getElementById("codigo").value,
                foto: document.getElementById("foto").src,
                tipo: document.getElementById("tipo").value,
                valor: document.getElementById("valor").value
            };

            jsonEnvio.acao = jsonEnvio.codigo ? "alterar" : "inserir";

            $.ajax({
                url: "ImovelServlet",
                data: jsonEnvio,
                type: "post",
                success: function(resp) {
                    alert(resp);
                    consultar();
                },
                error: function() {
                    alert("Ocorreu um erro ao salvar!");
                }
            });
        }

        function consultar() {
            var jsonEnvio = { acao: "consultar" };

            $.ajax({
                url: "ImovelServlet",
                data: jsonEnvio,
                type: "post",
                success: function(resp) {
                    var jsonVetor = JSON.parse(resp);
                    var linhas = "";

                    for (var i = 0; i < jsonVetor.length; i++) {
                        var codigo = jsonVetor[i].codigo;
                        var foto = jsonVetor[i].foto;
                        var tipo = jsonVetor[i].tipo;
                        var valor = jsonVetor[i].valor;

                        linhas += `
                            <tr>
                                <td><img src="imagens/edit.png" onclick="editar(${codigo}, '${foto}', '${tipo}', ${valor})" /></td>
                                <td><img src="imagens/delete.png" onclick="confirmarExcluir(${codigo})" /></td>
                                <td>${codigo}</td>
                                <td>${tipo}</td>
                                <td>${valor}</td>
                            </tr>
                        `;
                    }

                    document.getElementById("corpo_da_tabela").innerHTML = linhas;
                },
                error: function() {
                    alert("Ocorreu um erro ao consultar!");
                }
            });
        }

        function excluir(codigo) {
            var jsonEnvio = {
                acao: "excluir",
                codigo: codigo
            };

            $.ajax({
                url: "ImovelServlet",
                data: jsonEnvio,
                type: "post",
                success: function(resp) {
                    alert(resp);
                    consultar();
                },
                error: function() {
                    alert("Ocorreu um erro ao excluir!");
                }
            });
        }

        // Inicializa a tabela ao carregar a página
        consultar();
    </script>

</body>
</html>