<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="org.json.simple.parser.ParseException"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.PrintWriter"%>

<%
request.setCharacterEncoding("UTF-8");
String sSearchParas = URLDecoder.decode(request.getParameter("searchparas"), "UTF-8");
String stDay = "";
String enDay = "";
try {
	// JSONObject 생성 및 Parsing
	JSONParser jsonParser = new JSONParser();
	JSONObject jsonObject = (JSONObject) jsonParser.parse(sSearchParas);
	// Value 값 추출
	stDay = jsonObject.get("stDay").toString();
	enDay = jsonObject.get("enDay").toString();
	
	// MariaDB 준비
	Class.forName("org.mariadb.jdbc.Driver");
	// MariaDB 연결
	Connection con = DriverManager.getConnection("jdbc:mariadb://sc1.swu.ac.kr:13306/nijgnoey_ts","nijgnoey","nijgnoey1");
	// 쿼리
	String sql = "SELECT * FROM covid19Info WHERE gubun = ? AND (stdDay >= ? AND stdDay <= ?)";
	PreparedStatement stmt = con.prepareStatement(sql);
	stmt.setString(1, "합계");
	stmt.setString(2, stDay);
	stmt.setString(3, enDay);
	// 쿼리 실행
	ResultSet rs = stmt.executeQuery();
	JSONArray jArray = new JSONArray();
	while(rs.next()) {
		JSONObject resultJson = new JSONObject();
		resultJson.put("stdDay", rs.getString("stdDay"));
		resultJson.put("gubun", rs.getString("gubun"));
		resultJson.put("defCnt", rs.getInt("defCnt"));
		resultJson.put("deathCnt", rs.getInt("deathCnt"));
		resultJson.put("overFlowCnt", rs.getInt("overFlowCnt"));
		resultJson.put("localOccCnt", rs.getInt("localOccCnt"));
		if (resultJson != null) {
			jArray.add(resultJson);
		}
	}
	out.print(jArray);
	// DB 종료
	rs.close();
	stmt.close();
	con.close();
}
catch (Exception e) {
	e.printStackTrace();
}
%>