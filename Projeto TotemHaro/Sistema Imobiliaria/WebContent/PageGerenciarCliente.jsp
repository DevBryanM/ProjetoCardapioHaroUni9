<%@ include file="ProtecaoFuncionario.jsp" %>

<html>
<head>
	<meta charset="utf-8"/>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.js" integrity="sha512-+k1pnlgt4F1H8L7t3z95o3/KO+o78INEcXTbnoJQ/F2VqDVhWoaiVml/OEHv9HsVgxUaVW+IbiZPUJQfF/YxZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<title>Gerenciar Cliente</title>
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

    <a href="PageAreaAdministrativa.jsp">Voltar</a>
    <h2>Gerenciar Clientes</h2>
    
    <form>
        <label for="matricula">Matrícula: </label>
        <input type="text" id="matricula" disabled /><br />
        <label for="email">E-mail: </label>
        <input type="text" id="email" /><br />
        <label for="nome">Nome: </label>
        <input type="text" id="nome" /><br />
        <label for="senha">Senha: </label>
        <input type="text" id="senha" /><br />
        <label for="telefone">Telefone: </label>
        <input type="text" id="telefone" /><br /><br />

        <input type="button" value="Buscar" onclick="consultar()" />
        <input type="button" value="Salvar" onclick="inserirOuAlterar()" />
        <input type="reset" value="Limpar" /><br /><br />
    </form>

    <table>
        <thead>
            <tr>
                <th>Editar</th>
                <th>Excluir</th>
                <th>Matrícula</th>
                <th>E-mail</th>
                <th>Nome</th>
                <th>Telefone</th>
            </tr>
        </thead>
        <tbody id="corpo_da_tabela">
        </tbody>
    </table>

    <script>
        function editar(matricula, email, nome, telefone){
            document.getElementById("matricula").value = matricula;
            document.getElementById("email").value = email;
            document.getElementById("nome").value = nome;
            document.getElementById("telefone").value = telefone;
        }

        function confirmarExcluir(matricula){
            if (confirm("Deseja realmente excluir?")){
                excluir(matricula);
            }
        }

        function inserirOuAlterar(){
            var jsonEnvio = {};
            jsonEnvio.matricula = document.getElementById("matricula").value;
            jsonEnvio.email     = document.getElementById("email").value;
            jsonEnvio.nome      = document.getElementById("nome").value;
            jsonEnvio.senha     = document.getElementById("senha").value;
            jsonEnvio.telefone  = document.getElementById("telefone").value;
            if (jsonEnvio.matricula != ""){
                jsonEnvio.acao = "alterar";    
            } else {
                jsonEnvio.acao = "inserir";
            }
            $.ajax({
                url: "ClienteServlet",
                data: jsonEnvio,
                type: "post",
                success: function (resp){
                    if (resp == "ok"){
                        alert("Cliente cadastrado com sucesso!");
                        consultar();
                    } else {
                        alert(resp);
                    }
                },
                error: function (){
                    alert("Ocorreu um erro ao alterar!!!");
                }
            });
        }

        function consultar(){
            var jsonEnvio = {};
            jsonEnvio.acao = "consultar";
            $.ajax({
                url: "ClienteServlet",
                data: jsonEnvio,
                type: "post",
                success: function (resp){
                    document.getElementById("corpo_da_tabela").innerHTML = resp;
                },
                error: function (){
                    alert("Ocorreu um erro ao consultar cliente!!!");
                }
            });
        }

        function excluir(matricula){
            var jsonEnvio = {};
            jsonEnvio.acao = "excluir";
            jsonEnvio.matricula = matricula;
            $.ajax({
                url: "ClienteServlet",
                data: jsonEnvio,
                type: "post",
                success: function (resp){
                    alert(resp);
                    consultar();
                },
                error: function (){
                    alert("Ocorreu um erro ao excluir!!!");
                }
            });
        }
    </script>
</body>
</html>