<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
HttpSession userSession = request.getSession(false);
if(userSession == null || userSession.getAttribute("user") == null) {
    response.sendRedirect("Login_Servlet");
    return;
}

String userEmail = (String) request.getAttribute("userEmail");
double totalIncome = request.getAttribute("totalIncome") != null ? (Double) request.getAttribute("totalIncome") : 0;
double totalExpense = request.getAttribute("totalExpense") != null ? (Double) request.getAttribute("totalExpense") : 0;
double balance = totalIncome - totalExpense;
List<Map<String,String>> transactions = (List<Map<String,String>>) request.getAttribute("transactions");
Map<String,Double> categories = (Map<String,Double>) request.getAttribute("categories");
if(transactions == null) transactions = new ArrayList<>();
if(categories == null) categories = new LinkedHashMap<>();
String successMsg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BankingApp — Dashboard</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap');
*{margin:0;padding:0;box-sizing:border-box}
:root{--bg:#0f0f1a;--sidebar:#16162a;--card:#1e1e35;--card2:#252540;--accent:#7c6fff;--accent2:#00d4aa;--accent3:#ff6b9d;--text:#e8e8ff;--muted:#8888aa;--border:#2a2a45;}
body{background:var(--bg);color:var(--text);font-family:'Space Grotesk',sans-serif;display:flex;height:100vh;overflow:hidden;font-size:13px}
.sidebar{width:200px;background:var(--sidebar);border-right:1px solid var(--border);display:flex;flex-direction:column;padding:20px 0;flex-shrink:0}
.logo{padding:0 20px 24px;font-size:18px;font-weight:600;color:var(--accent);letter-spacing:1px}
.logo span{color:var(--accent2)}
.nav-item{display:flex;align-items:center;gap:10px;padding:10px 20px;color:var(--muted);font-size:13px;border-left:3px solid transparent;text-decoration:none}
.nav-item:hover{color:var(--text);background:rgba(124,111,255,0.08)}
.nav-item.active{color:var(--accent);background:rgba(124,111,255,0.12);border-left:3px solid var(--accent)}
.nav-divider{height:1px;background:var(--border);margin:12px 20px}
.sidebar-bottom{margin-top:auto}
.main{flex:1;display:flex;flex-direction:column;overflow:hidden}
.topbar{display:flex;align-items:center;justify-content:space-between;padding:16px 24px;border-bottom:1px solid var(--border)}
.welcome{font-size:16px;font-weight:500}
.welcome span{color:var(--accent2)}
.content{flex:1;overflow-y:auto;padding:20px 24px;display:flex;flex-direction:column;gap:16px}
.row{display:grid;gap:12px}
.row-3{grid-template-columns:repeat(3,1fr)}
.row-2{grid-template-columns:1.4fr 1fr}
.row-bottom{grid-template-columns:1fr 1fr 1.1fr}
.card{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:16px}
.card-label{font-size:11px;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:6px}
.card-value{font-size:22px;font-weight:600;font-family:'DM Mono',monospace}
.card-sub{font-size:11px;color:var(--accent2);margin-top:4px}
.card-sub.neg{color:var(--accent3)}
.stat-balance{border-top:2px solid var(--accent)}
.stat-income{border-top:2px solid var(--accent2)}
.stat-expense{border-top:2px solid var(--accent3)}
.chart-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px}
.chart-title{font-size:13px;font-weight:500}
.chart-legend{display:flex;gap:12px}
.legend-item{display:flex;align-items:center;gap:5px;font-size:11px;color:var(--muted)}
.legend-dot{width:8px;height:8px;border-radius:50%}
.chart-area{position:relative;height:110px}
.donut-wrap{display:flex;align-items:center;gap:16px;margin-top:8px}
.donut-labels{display:flex;flex-direction:column;gap:8px}
.donut-label{display:flex;align-items:center;gap:6px;font-size:11px;color:var(--muted)}
.donut-swatch{width:8px;height:8px;border-radius:2px;flex-shrink:0}
.tx-item{display:flex;align-items:center;justify-content:space-between;padding:8px 0;border-bottom:1px solid var(--border)}
.tx-item:last-child{border-bottom:none}
.tx-left{display:flex;align-items:center;gap:10px}
.tx-icon{width:32px;height:32px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:14px;flex-shrink:0}
.tx-name{font-size:13px;font-weight:500}
.tx-date{font-size:11px;color:var(--muted)}
.tx-amount{font-size:13px;font-weight:600;font-family:'DM Mono',monospace}
.tx-amount.inc{color:var(--accent2)}
.tx-amount.exp{color:var(--accent3)}
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:12px}
.form-group{display:flex;flex-direction:column;gap:5px}
.form-group.full{grid-column:1/-1}
.form-label{font-size:11px;color:var(--muted)}
.form-input{background:var(--card2);border:1px solid var(--border);border-radius:8px;padding:8px 12px;color:var(--text);font-size:12px;font-family:inherit;outline:none;transition:border 0.2s;width:100%}
.form-input:focus{border-color:var(--accent)}
select.form-input option{background:var(--card2)}
.form-btn{grid-column:1/-1;background:var(--accent);border:none;border-radius:8px;padding:10px;color:#fff;font-size:13px;font-weight:600;cursor:pointer;font-family:inherit;width:100%}
.form-btn:hover{opacity:0.85}
.empty{color:var(--muted);font-size:12px;padding:20px 0;text-align:center}
.msg{background:rgba(0,212,170,0.1);border:1px solid var(--accent2);color:var(--accent2);border-radius:8px;padding:8px 12px;font-size:12px;grid-column:1/-1}
</style>
</head>
<body>

<div class="sidebar">
  <div class="logo">III <span>BANK</span></div>
  <a class="nav-item active" href="Dashboard_Servlet">
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><rect x="1" y="1" width="6" height="6" rx="1" fill="currentColor"/><rect x="9" y="1" width="6" height="6" rx="1" fill="currentColor" opacity=".5"/><rect x="1" y="9" width="6" height="6" rx="1" fill="currentColor" opacity=".5"/><rect x="9" y="9" width="6" height="6" rx="1" fill="currentColor" opacity=".5"/></svg>
    Analytics
  </a>
  <a class="nav-item" href="#">
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M2 5h12M2 8h8M2 11h6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
    Transactions
  </a>
  <a class="nav-item" href="#">
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="6" r="3" stroke="currentColor" stroke-width="1.5"/><path d="M2 14c0-3.314 2.686-5 6-5s6 1.686 6 5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
    Profile
  </a>
  <div class="nav-divider"></div>
  <a class="nav-item" href="#">
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="2" stroke="currentColor" stroke-width="1.5"/><path d="M8 1v2M8 13v2M1 8h2M13 8h2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
    Settings
  </a>
  <div class="sidebar-bottom">
    <a class="nav-item" href="Logout_Servlet">
      <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M6 3H3a1 1 0 00-1 1v8a1 1 0 001 1h3M10 11l3-3-3-3M13 8H6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
      Log Out
    </a>
  </div>
</div>

<div class="main">
  <div class="topbar">
    <div class="welcome">Hello, <span><%= userEmail != null ? userEmail.split("@")[0] : "" %></span> — Welcome Back</div>
  </div>

  <div class="content">
    <div class="row row-3">
      <div class="card stat-balance">
        <div class="card-label">Total Balance</div>
        <div class="card-value">$<%= String.format("%.2f", balance) %></div>
        <div class="card-sub <%= balance < 0 ? "neg" : "" %>"><%= balance >= 0 ? "Positive balance" : "Negative balance" %></div>
      </div>
      <div class="card stat-income">
        <div class="card-label">Total Income</div>
        <div class="card-value">$<%= String.format("%.2f", totalIncome) %></div>
        <div class="card-sub">All time income</div>
      </div>
      <div class="card stat-expense">
        <div class="card-label">Total Expenses</div>
        <div class="card-value">$<%= String.format("%.2f", totalExpense) %></div>
        <div class="card-sub neg">All time expenses</div>
      </div>
    </div>

    <div class="row row-2">
      <div class="card">
        <div class="chart-header">
          <div class="chart-title">Financial Analytics</div>
          <div class="chart-legend">
            <div class="legend-item"><div class="legend-dot" style="background:#00d4aa"></div>Income</div>
            <div class="legend-item"><div class="legend-dot" style="background:#ff6b9d"></div>Expenses</div>
          </div>
        </div>
        <div class="chart-area"><canvas id="lineChart"></canvas></div>
      </div>
      <div class="card">
        <div class="chart-header"><div class="chart-title">Spending Categories</div></div>
        <div class="donut-wrap">
          <canvas id="donutChart" width="100" height="100" style="width:100px;height:100px;flex-shrink:0"></canvas>
          <div class="donut-labels">
            <% if(categories.isEmpty()) { %>
              <span style="color:var(--muted);font-size:11px">No expenses yet</span>
            <% } else {
              String[] catColors = {"#7c6fff","#00d4aa","#ff6b9d","#ffd166","#06d6a0","#ef476f"};
              int ci = 0;
              for(Map.Entry<String,Double> entry : categories.entrySet()) { %>
                <div class="donut-label">
                  <div class="donut-swatch" style="background:<%= catColors[ci % catColors.length] %>"></div>
                  <%= entry.getKey() %> ($<%= String.format("%.0f", entry.getValue()) %>)
                </div>
            <% ci++; } } %>
          </div>
        </div>
      </div>
    </div>

    <div class="row row-bottom">
      <div class="card">
        <div class="chart-header"><div class="chart-title">Recent Transactions</div></div>
        <% if(transactions.isEmpty()) { %>
          <div class="empty">No transactions yet</div>
        <% } else { for(Map<String,String> tx : transactions) {
          boolean isIncome = tx.get("type").equals("income"); %>
          <div class="tx-item">
            <div class="tx-left">
              <div class="tx-icon" style="background:<%= isIncome ? "rgba(0,212,170,0.15)" : "rgba(255,107,157,0.15)" %>">
                <%= isIncome ? "↑" : "↓" %>
              </div>
              <div>
                <div class="tx-name"><%= tx.get("category") %></div>
                <div class="tx-date"><%= tx.get("date") %><%= !tx.get("description").isEmpty() ? " — " + tx.get("description") : "" %></div>
              </div>
            </div>
            <div class="tx-amount <%= isIncome ? "inc" : "exp" %>">
              <%= isIncome ? "+" : "-" %>$<%= String.format("%.2f", Double.parseDouble(tx.get("amount"))) %>
            </div>
          </div>
        <% } } %>
      </div>

      <div class="card">
        <div class="chart-header"><div class="chart-title">Income vs Expenses</div></div>
        <div class="chart-area"><canvas id="barChart"></canvas></div>
      </div>

      <div class="card">
        <div class="chart-title">Add Transaction</div>
        <form action="Transaction_Servlet" method="post">
          <div class="form-grid">
            <% if(successMsg != null) { %>
              <div class="msg"><%= successMsg %></div>
            <% } %>
            <div class="form-group">
              <div class="form-label">Type</div>
              <select class="form-input" name="type">
                <option value="income">Income</option>
                <option value="expense">Expense</option>
              </select>
            </div>
            <div class="form-group">
              <div class="form-label">Amount ($)</div>
              <input class="form-input" type="number" name="amount" placeholder="0.00" step="0.01" min="0" required>
            </div>
            <div class="form-group">
              <div class="form-label">Category</div>
              <input class="form-input" type="text" name="category" placeholder="e.g. Salary, Food" required>
            </div>
            <div class="form-group">
              <div class="form-label">Date</div>
              <input class="form-input" type="date" name="transaction_date" required>
            </div>
            <div class="form-group full">
              <div class="form-label">Description (optional)</div>
              <input class="form-input" type="text" name="description" placeholder="Note...">
            </div>
            <button class="form-btn" type="submit">Save Transaction</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
<script>
Chart.defaults.color='#8888aa';
Chart.defaults.borderColor='#2a2a45';
Chart.defaults.font.family='Space Grotesk';

new Chart(document.getElementById('lineChart').getContext('2d'),{
  type:'line',
  data:{
    labels:['Mon','Tue','Wed','Thu','Fri','Sat','Sun'],
    datasets:[
      {label:'Income',data:[0,0,0,<%=totalIncome/7%>,0,0,0],borderColor:'#00d4aa',backgroundColor:'rgba(0,212,170,0.08)',tension:0.4,fill:true,pointRadius:2},
      {label:'Expenses',data:[0,0,0,<%=totalExpense/7%>,0,0,0],borderColor:'#ff6b9d',backgroundColor:'rgba(255,107,157,0.08)',tension:0.4,fill:true,pointRadius:2}
    ]
  },
  options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{x:{grid:{display:false}},y:{grid:{color:'#2a2a45'}}}}
});

const catVals=[<% int ci3=0; for(Double v:categories.values()){%><%=v%><%if(++ci3<categories.size())out.print(",");}%>];
const catLabels=[<% int ci2=0; for(String k:categories.keySet()){%>'<%=k%>'<%if(++ci2<categories.size())out.print(",");}%>];
new Chart(document.getElementById('donutChart').getContext('2d'),{
  type:'doughnut',
  data:{labels:catLabels,datasets:[{data:catVals.length>0?catVals:[1],backgroundColor:catVals.length>0?['#7c6fff','#00d4aa','#ff6b9d','#ffd166','#06d6a0','#ef476f']:['#2a2a45'],borderWidth:0}]},
  options:{responsive:false,plugins:{legend:{display:false}},cutout:'72%'}
});

new Chart(document.getElementById('barChart').getContext('2d'),{
  type:'bar',
  data:{
    labels:['Income','Expenses'],
    datasets:[{data:[<%=totalIncome%>,<%=totalExpense%>],backgroundColor:['rgba(0,212,170,0.7)','rgba(255,107,157,0.7)'],borderRadius:6,borderWidth:0}]
  },
  options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{x:{grid:{display:false}},y:{grid:{color:'#2a2a45'}}}}
});
</script>
</body>
</html>