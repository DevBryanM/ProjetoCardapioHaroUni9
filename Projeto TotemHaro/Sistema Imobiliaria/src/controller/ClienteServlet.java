package controller;

import java.io.IOException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import model.Imovel;


/**
 * Servlet implementation class FuncionarioServlet
 */
@WebServlet("/ClienteServlet")
public class ClienteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ClienteServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//doGet(request, response);
		
		response.setCharacterEncoding("utf-8");
		
		String acao  = request.getParameter("acao");
		try { 
			if (acao.equals("login")) {
				login(request, response);
			}else if (acao.equals("logout")) {
				logout(request, response);
			}else if (acao.equals("consultar")) {
				consultar(request, response);
			}else if (acao.equals("inserir")) {
				inserir(request, response);
			}else if (acao.equals("alterar")) {
				alterar(request, response);
			}else if (acao.equals("excluir")) {
				excluir(request, response);
			}
			
		}catch(Exception e) {
			response.getWriter().append("Ocorreu um erro na solicitação para " + acao);
		}		
	}
	
	public Connection getConection() throws Exception{
		Connection conn = null;
		Class.forName("org.sqlite.JDBC");
		String diretorio = System.getProperty("wtp.deploy").toString().split(".metadata")[0];
		String dataBase = diretorio + "\\clientebase.db";
		conn = DriverManager.getConnection("jdbc:sqlite:"+dataBase);
		return conn;
	}
	
	public void logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession(true);
		session.invalidate();
		response.getWriter().append("ok");
	}
	
	public void login(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String email = request.getParameter("email");
	    String senha = request.getParameter("senha");

	    // Fun��o que gera o hash MD5 da senha
	    senha = md5(senha);
	    
	    // Estabelecendo a conex�o com o banco de dados
	    Connection conn = getConection();
	    String sql = "SELECT * FROM cliente WHERE email=? AND senha=?";
	    PreparedStatement pstm = conn.prepareStatement(sql);
	    
	    // Definindo os par�metros da consulta
	    pstm.setString(1, email);
	    pstm.setString(2, senha);
	    
	    ResultSet rs = pstm.executeQuery();
	    
	    // Verificando se o usu�rio existe
	    if (rs.next()) {
	        // Se o usu�rio for encontrado, autenticado com sucesso
	        response.getWriter().append("ok");
	        
	        // Criando a sess�o e armazenando o nome do usu�rio
	        HttpSession session = request.getSession(true);
	        session.setAttribute("nome", rs.getString(3)); // Supondo que o nome do usu�rio est� na 3� coluna
	    } else {
	        // Se o usu�rio n�o for encontrado, invalidando a sess�o
	        response.getWriter().append("erro");
	        HttpSession session = request.getSession(true);
	        session.invalidate();
	    }
	    
	    // Fechando a conex�o com o banco de dados
	    conn.close();
	}

	// Fun��o para gerar o hash MD5
	public String md5(String senha) throws Exception {
	    MessageDigest md = MessageDigest.getInstance("MD5");
	    byte[] hashBytes = md.digest(senha.getBytes());
	    
	    // Converter bytes em formato hexadecimal
	    StringBuilder sb = new StringBuilder();
	    for (byte b : hashBytes) {
	        sb.append(String.format("%02x", b));
	    }
	    return sb.toString();
	}
	
	public void consultar(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Connection conn = getConection();		
		String sql = "select * from cliente";
		PreparedStatement pstm = conn.prepareStatement(sql);								
		ResultSet rs = pstm.executeQuery();				
		while(rs.next()) {
			String col1 = "<td><img src='imagens/edit.png' onclick='editar("+ rs.getInt(4) + ",\""+ rs.getString(2) +"\",\""+  rs.getString(1) + "\",\""+ rs.getString(5) + "\")'/></td>";
			String col2 = "<td><img src='imagens/delete.png' onclick='confirmarExcluir("+ rs.getInt(4) + ")'/></td>";
			String col3 = "<td>" + rs.getInt(4) + "</td>"; //matricula
			String col4 = "<td>" + rs.getString(2) + "</td>"; //email
			String col5 = "<td>" + rs.getString(1) + "</td>"; //nome
			String col6 = "<td>" + rs.getString(5) + "</td>"; //telefone		
			String linha = "<tr>"+col1+col2+col3+col4+col5+col6+"</tr>";
			response.getWriter().append(linha);
		}
		//Neste exemplo estamos j� retornando as linhas montadas para a tabela html
		//Poder�amos retornar um json da mesma forma que fizemos com os im�veis
		conn.close();	
	}
	
	public void inserir(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String email    = request.getParameter("email");
		String nome     = request.getParameter("nome");
		String senha    = request.getParameter("senha");
		String telefone = request.getParameter("telefone");
		String matricula = request.getParameter("matricula");
		
		MessageDigest md = MessageDigest.getInstance("MD5");
		BigInteger hash  = new BigInteger(1, md.digest(senha.getBytes()));
	    senha = hash.toString(16); //transformando a senha em hash		
		
		Connection conn = getConection();		
		String sql = "insert into cliente(nome,email,senha,matricula, telefone) values(?,?,?,?,?)";
		PreparedStatement psm = conn.prepareStatement(sql);
		psm.setString(1, nome);
		psm.setString(2, email);
		psm.setString(3, senha);
		psm.setString(4, matricula);
		psm.setString(5, telefone);
		int qtdAfetadas = psm.executeUpdate();
		if (qtdAfetadas>0) {
			String msg = "ok";
			response.getWriter().append(msg);
		}else {
			String msg = "N�o foi possivel inserir!";
			response.getWriter().append(msg);
		}
		conn.close();	
	}
	
	public void alterar(HttpServletRequest request, HttpServletResponse response) throws Exception {

		int matricula   = Integer.parseInt(request.getParameter("matricula"));
		String email    = request.getParameter("email");
		String nome     = request.getParameter("nome");
		String senha    = request.getParameter("senha"); 
		String telefone = request.getParameter("telefone");
				
		MessageDigest md = MessageDigest.getInstance("MD5");
		BigInteger hash = new BigInteger(1, md.digest(senha.getBytes()));
	    senha = hash.toString(16); //transformando a senha em hash para proteger a senha		
		
		Connection conn = getConection();		
		String sql = "update cliente set nome=?, email=?, senha=?, telefone=? where matricula=?";
		PreparedStatement psm = conn.prepareStatement(sql);
		psm.setString(2, email);
		psm.setString(1, nome);
		psm.setString(3, senha);
		psm.setString(4, telefone);
		psm.setInt(5, matricula);
		int qtdAfetadas = psm.executeUpdate();
		if (qtdAfetadas>0) {
			String msg = "Dados alterados com sucesso!";
			response.getWriter().append(msg);
		}else {
			String msg = "N�o foi possivel alterar!";
			response.getWriter().append(msg);
		}
		conn.close();
		
	}
	
	public void excluir(HttpServletRequest request, HttpServletResponse response) throws Exception {

		int matricula = Integer.parseInt(request.getParameter("matricula")); 
		Connection conn = getConection();
		String sql = "delete from cliente where matricula=?";
		PreparedStatement psm = conn.prepareStatement(sql);
		psm.setInt(1, matricula);
		int qtdAfetadas = psm.executeUpdate();		
		if (qtdAfetadas>0) {
			String msg = "Dados excluidos com sucesso!";
			response.getWriter().append(msg);
		}else {
			String msg = "N�o foi possivel excluir!";
			response.getWriter().append(msg);
		}
		conn.close();
	}
}