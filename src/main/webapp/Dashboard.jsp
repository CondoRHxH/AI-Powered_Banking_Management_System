<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
HttpSession userSession = request.getSession(false);
if(userSession == null || userSession.getAttribute("user") == null) {  //Import de session
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
String displayName = (userEmail != null) ? userEmail.split("@")[0] : "User";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BankingApp — Dashboard</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap');
*{margin:0;padding:0;box-sizing:border-box}
:root{--bg:#0a0a12;--s1:#12121f;--s2:#1a1a2e;--s3:#22223b;--p:#a78bfa;--p2:#38bdf8;--p3:#fb7185;--p4:#34d399;--p5:#fbbf24;--t:#f1f0ff;--m:#9998bb;--b:#ffffff18;}
body{background:var(--bg);color:var(--t);font-family:'Outfit',sans-serif;display:flex;height:100vh;overflow:hidden;font-size:13px}
.sidebar{width:210px;background:var(--s1);border-right:1px solid var(--b);display:flex;flex-direction:column;padding:24px 0;flex-shrink:0}
.logo{padding:0 20px 28px;font-size:20px;font-weight:700;letter-spacing:2px}
.logo .l1{color:var(--p)}.logo .l2{color:var(--p2)}
.nav{display:flex;flex-direction:column;gap:2px;padding:0 12px}
.ni{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:10px;color:var(--m);font-size:13px;text-decoration:none;font-weight:400;transition:all .2s;border:1px solid transparent}
.ni:hover{background:var(--b);color:var(--t)}
.ni.on{background:linear-gradient(135deg,#a78bfa22,#38bdf822);color:var(--p);border:1px solid #a78bfa33}
.ni svg{width:16px;height:16px;flex-shrink:0}
.ndiv{height:1px;background:var(--b);margin:12px 0}
.sb-bot{margin-top:auto;padding:0 12px}
.main{flex:1;display:flex;flex-direction:column;overflow:hidden}
.topbar{display:flex;align-items:center;justify-content:space-between;padding:18px 24px;border-bottom:1px solid var(--b)}
.greet{font-size:15px;font-weight:600}
.greet em{color:var(--p);font-style:normal}
.tbr{display:flex;align-items:center;gap:10px}
.srch{background:var(--s2);border:1px solid var(--b);border-radius:10px;padding:7px 14px;color:var(--t);font-size:12px;width:170px;outline:none;font-family:inherit}
.avt{width:34px;height:34px;border-radius:10px;background:linear-gradient(135deg,#a78bfa,#38bdf8);display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;color:#fff;text-transform:uppercase}
.content{flex:1;overflow-y:auto;padding:20px 24px;display:flex;flex-direction:column;gap:14px}
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.g2a{display:grid;grid-template-columns:1.5fr 1fr;gap:12px}
.g3b{display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px}
.card{background:var(--s2);border:1px solid var(--b);border-radius:14px;padding:16px;position:relative;overflow:hidden}
.card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px}
.ca::before{background:linear-gradient(90deg,#a78bfa,#818cf8)}
.cb::before{background:linear-gradient(90deg,#34d399,#38bdf8)}
.cc::before{background:linear-gradient(90deg,#fb7185,#f43f5e)}
.clabel{font-size:10px;color:var(--m);text-transform:uppercase;letter-spacing:1px;margin-bottom:8px;font-weight:500}
.cval{font-size:24px;font-weight:700;font-family:'DM Mono',monospace;letter-spacing:-1px}
.csub{font-size:11px;margin-top:6px;display:flex;align-items:center;gap:6px;color:var(--m)}
.pill{display:inline-flex;align-items:center;padding:2px 8px;border-radius:20px;font-size:10px;font-weight:600}
.pill-up{background:#34d39922;color:var(--p4)}
.pill-dn{background:#fb718522;color:var(--p3)}
.chtop{display:flex;justify-content:space-between;align-items:center;margin-bottom:14px}
.chtitle{font-size:13px;font-weight:600}
.leg{display:flex;gap:14px}
.legi{display:flex;align-items:center;gap:5px;font-size:11px;color:var(--m)}
.legdot{width:8px;height:8px;border-radius:50%}
.cha{position:relative;height:120px}
.dwrap{display:flex;align-items:center;gap:14px;margin-top:8px}
.dlabs{display:flex;flex-direction:column;gap:8px;flex:1}
.dlab{display:flex;align-items:center;justify-content:space-between;font-size:11px}
.dleft{display:flex;align-items:center;gap:6px;color:var(--m)}
.dsw{width:8px;height:8px;border-radius:2px;flex-shrink:0}
.dval{font-family:'DM Mono',monospace;font-size:11px;color:var(--t)}
.txi{display:flex;align-items:center;justify-content:space-between;padding:9px 0;border-bottom:1px solid var(--b)}
.txi:last-child{border-bottom:none}
.txl{display:flex;align-items:center;gap:10px}
.txico{width:34px;height:34px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:14px;font-weight:700;flex-shrink:0;font-family:'DM Mono',monospace}
.txn{font-size:13px;font-weight:500}
.txd{font-size:10px;color:var(--m);margin-top:1px}
.txa{font-size:13px;font-weight:600;font-family:'DM Mono',monospace}
.inc{color:var(--p4)}.exp{color:var(--p3)}
.empty{color:var(--m);font-size:12px;text-align:center;padding:20px 0}
.ai-card{background:linear-gradient(135deg,#1a1a3e,#1e1e35) !important;border:1px solid #a78bfa33 !important}
.ai-pulse{display:flex;align-items:center;gap:6px;margin-bottom:10px}
.ai-dot{width:8px;height:8px;border-radius:50%;background:var(--p);animation:pulse 2s infinite}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.3}}
.ai-label{font-size:10px;color:var(--p);font-weight:600;text-transform:uppercase;letter-spacing:1px}
.ai-msg{font-size:12px;color:var(--m);line-height:1.7;min-height:55px}
.ai-input{background:var(--s3);border:1px solid var(--b);border-radius:8px;padding:7px 10px;color:var(--t);font-size:12px;font-family:inherit;outline:none;width:100%;margin-top:8px;transition:border .2s}
.ai-input:focus{border-color:var(--p)}
.ai-loading{color:var(--p);font-size:11px;margin-top:4px;display:none}
.ai-btn{margin-top:8px;background:#a78bfa22;border:1px solid #a78bfa44;border-radius:8px;padding:7px 12px;color:var(--p);font-size:11px;font-weight:600;cursor:pointer;font-family:inherit;width:100%;transition:background .2s}
.ai-btn:hover{background:#a78bfa33}
.fgrid{display:grid;grid-template-columns:1fr 1fr;gap:9px;margin-top:12px}
.fg{display:flex;flex-direction:column;gap:4px}
.fl{font-size:10px;color:var(--m);text-transform:uppercase;letter-spacing:.5px;font-weight:500}
.fi{background:var(--s3);border:1px solid var(--b);border-radius:9px;padding:8px 11px;color:var(--t);font-size:12px;font-family:inherit;outline:none;width:100%;transition:border .2s}
.fi:focus{border-color:var(--p)}
select.fi option{background:var(--s3)}
.full{grid-column:1/-1}
.fbtn{grid-column:1/-1;background:linear-gradient(135deg,#a78bfa,#818cf8);border:none;border-radius:10px;padding:11px;color:#fff;font-size:13px;font-weight:600;cursor:pointer;font-family:inherit;letter-spacing:.3px;transition:opacity .2s}
.fbtn:hover{opacity:.9}
.smsg{background:#34d39922;border:1px solid #34d39944;color:var(--p4);border-radius:8px;padding:8px 12px;font-size:12px;grid-column:1/-1}
</style>
</head>
<body>

<div class="sidebar">
  <div class="logo"><span class="l1">III</span> <span class="l2">BANK</span></div>
  <div class="nav">
    <a class="ni on" href="Dashboard_Servlet">
      <svg viewBox="0 0 16 16" fill="none"><rect x="1" y="1" width="6" height="6" rx="1.5" fill="currentColor"/><rect x="9" y="1" width="6" height="6" rx="1.5" fill="currentColor" opacity=".5"/><rect x="1" y="9" width="6" height="6" rx="1.5" fill="currentColor" opacity=".5"/><rect x="9" y="9" width="6" height="6" rx="1.5" fill="currentColor" opacity=".5"/></svg>
      Analytics
    </a>
    <div class="ndiv"></div>
    <a class="ni" href="Transactions_Servlet" style="color:var(--m)">
      Transactions
    </a>
  </div>
  <div class="sb-bot">
    <a class="ni" href="Logout_Servlet" style="color:#fb718599">
      <svg viewBox="0 0 16 16" fill="none"><path d="M6 3H3a1 1 0 00-1 1v8a1 1 0 001 1h3M10 11l3-3-3-3M13 8H6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
      Log Out
    </a>
  </div>
</div>

<div class="main">
  <div class="topbar">
    <div class="greet">Good day, <em><%= displayName %></em> — here's your overview</div>
    <div class="tbr">
      <input class="srch" placeholder="Search transactions...">
      <div class="avt"><%= displayName.substring(0,1).toUpperCase() %></div>
    </div>
  </div>

  <div class="content">

    <div class="g3">
      <div class="card ca">
        <div class="clabel">Total Balance</div>
        <div class="cval">$<%= String.format("%.2f", balance) %></div>
        <div class="csub">
          <span class="pill <%= balance>=0?"pill-up":"pill-dn" %>"><%= balance>=0?"+":"-" %><%= String.format("%.1f", totalIncome>0?Math.abs(balance/totalIncome)*100:0) %>%</span>
          net ratio
        </div>
      </div>
      <div class="card cb">
        <div class="clabel">Total Income</div>
        <div class="cval">$<%= String.format("%.2f", totalIncome) %></div>
        <div class="csub"><span class="pill pill-up">all time</span> earnings</div>
      </div>
      <div class="card cc">
        <div class="clabel">Total Expenses</div>
        <div class="cval">$<%= String.format("%.2f", totalExpense) %></div>
        <div class="csub"><span class="pill pill-dn">all time</span> spending</div>
      </div>
    </div>

    <div class="g2a">
      <div class="card">
        <div class="chtop">
          <div class="chtitle">Financial Analytics</div>
          <div class="leg">
            <div class="legi"><div class="legdot" style="background:#34d399"></div>Income</div>
            <div class="legi"><div class="legdot" style="background:#fb7185"></div>Expenses</div>
          </div>
        </div>
        <div class="cha"><canvas id="lineChart"></canvas></div>
      </div>
      <div class="card">
        <div class="chtop"><div class="chtitle">Spending Categories</div></div>
        <div class="dwrap">
          <canvas id="donutChart" width="90" height="90" style="width:90px;height:90px;flex-shrink:0"></canvas>
          <div class="dlabs">
            <% if(categories.isEmpty()) { %>
              <span style="color:var(--m);font-size:11px">No expenses yet</span>
            <% } else {
              String[] cc = {"#00000","#34d399","#fb7185","#fbbf24","#38bdf8","#f472b6"};
              int ci=0;
              for(Map.Entry<String,Double> e : categories.entrySet()) { %>
                <div class="dlab">
                  <div class="dleft"><div class="dsw" style="background:<%= cc[ci%cc.length] %>"></div><%= e.getKey() %></div>
                  <div class="dval">$<%= String.format("%.0f", e.getValue()) %></div>
                </div>
            <% ci++; } } %>
          </div>
        </div>
      </div>
    </div>

    <div class="g3b">
      <div class="card">
        <div class="chtop"><div class="chtitle">Recent Transactions</div></div>
        <% if(transactions.isEmpty()) { %>
          <div class="empty">No transactions yet</div>
        <% } else { for(Map<String,String> tx : transactions) {
          boolean isIncome = "income".equals(tx.get("type")); %>
          <div class="txi">
            <div class="txl">
              <div class="txico" style="background:<%= isIncome?"#34d39922":"#fb718522" %>;color:<%= isIncome?"#34d399":"#fb7185" %>">
                <%= isIncome?"+":"-" %>
              </div>
              <div>
                <div class="txn"><%= tx.get("category") %></div>
                <div class="txd"><%= tx.get("date") %><%= !tx.get("description").isEmpty()?" — "+tx.get("description"):"" %></div>
              </div>
            </div>
            <div class="txa <%= isIncome?"inc":"exp" %>">
              <%= isIncome?"+":"-" %>$<%= String.format("%.2f", Double.parseDouble(tx.get("amount"))) %>
            </div>
          </div>
        <% } } %>
      </div>

      <div class="card ai-card">
        <div class="ai-pulse">
          <div class="ai-dot"></div>
          <div class="ai-label">AI Financial Advisor</div>
        </div>
        <div class="ai-msg" id="ai-msg">
          <% if(totalIncome==0 && totalExpense==0) { %>
            Start adding transactions and I'll analyze your finances!
          <% } else { %>
            Balance $<%= String.format("%.2f",balance) %> — you've spent <%= totalIncome>0?String.format("%.0f",(totalExpense/totalIncome)*100):"0" %>% of income. <%= balance>=0?"Keep it up!":"Watch your spending!" %>
          <% } %>
        </div>
        <input class="ai-input" id="ai-input" type="text" placeholder="Ask your AI advisor...">
        <div class="ai-loading" id="ai-loading">Thinking...</div>
        <button class="ai-btn" onclick="askAI()">Ask AI Advisor</button>
      </div>

      <div class="card">
        <div class="chtitle">Add Transaction</div>
        <form action="Transaction_Servlet" method="post">
          <div class="fgrid">
            <% if(successMsg != null) { %>
              <div class="smsg"><%= successMsg %></div>
            <% } %>
            <div class="fg">
              <div class="fl">Type</div>
              <select class="fi" name="type">
                <option value="income">Income</option>
                <option value="expense">Expense</option>
              </select>
            </div>
            <div class="fg">
              <div class="fl">Amount ($)</div>
              <input class="fi" type="number" name="amount" placeholder="0.00" step="0.01" min="0" required>
            </div>
            <div class="fg">
              <div class="fl">Category</div>
              <input class="fi" type="text" name="category" placeholder="e.g. Salary" required>
            </div>
            <div class="fg">
              <div class="fl">Date</div>
              <input class="fi" type="date" name="transaction_date" required>
            </div>
            <div class="fg full">
              <div class="fl">Note</div>
              <input class="fi" type="text" name="description" placeholder="Optional...">
            </div>
            <button class="fbtn" type="submit">Save Transaction</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
<script>
Chart.defaults.color='#9998bb';
Chart.defaults.borderColor='#ffffff18';
Chart.defaults.font.family='Outfit';

new Chart(document.getElementById('lineChart'),{
  type:'line',
  data:{
    labels:['Mon','Tue','Wed','Thu','Fri','Sat','Sun'],
    datasets:[
      {label:'Income',data:[0,0,0,<%=totalIncome/7%>,0,0,0],borderColor:'#34d399',backgroundColor:'#34d39918',tension:0.4,fill:true,pointRadius:3,pointBackgroundColor:'#34d399'},
      {label:'Expenses',data:[0,0,0,<%=totalExpense/7%>,0,0,0],borderColor:'#fb7185',backgroundColor:'#fb718518',tension:0.4,fill:true,pointRadius:3,pointBackgroundColor:'#fb7185'}
    ]
  },
  options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{x:{grid:{display:false}},y:{grid:{color:'#ffffff0a'}}}}
});

const catVals=[<% int ci3=0;for(Double v:categories.values()){%><%=v%><%if(++ci3<categories.size())out.print(",");}%>];
const catLabels=[<% int ci2=0;for(String k:categories.keySet()){%>'<%=k%>'<%if(++ci2<categories.size())out.print(",");}%>];
new Chart(document.getElementById('donutChart'),{
  type:'doughnut',
  data:{labels:catLabels,datasets:[{data:catVals.length>0?catVals:[1],backgroundColor:catVals.length>0?['#00000','#34d399','#fb7185','#fbbf24','#38bdf8','#f472b6']:['#ffffff18'],borderWidth:0,hoverOffset:4}]},
  options:{responsive:false,plugins:{legend:{display:false}},cutout:'75%'}
});

async function askAI(){
  const q=document.getElementById('ai-input').value.trim();
  if(!q) return;
  const msg=document.getElementById('ai-msg');
  const load=document.getElementById('ai-loading');
  load.style.display='block';
  msg.style.opacity='0.4';
  const ctx=`User finances: balance $<%=String.format("%.2f",balance)%>, income $<%=String.format("%.2f",totalIncome)%>, expenses $<%=String.format("%.2f",totalExpense)%>. Question: ${q}. Reply in 2-3 short sentences with practical advice.`;   //On calcule et transmettre au AI
  try{
    const res=await fetch('http://localhost:11434/api/generate',{
      method:'POST',
      headers:{'Content-Type':'application/json'},
      body:JSON.stringify({model:'llama3.2',prompt:ctx,stream:false})
    });
    const data=await res.json();
    msg.textContent=data.response||'No response received.';
  }catch(e){
    msg.textContent='AI advisor offline. Make sure Ollama is running with: ollama run llama3.2';
  }
  load.style.display='none';
  msg.style.opacity='1';
  document.getElementById('ai-input').value='';
}
</script>
</body>
</html>
