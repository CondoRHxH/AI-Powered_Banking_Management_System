<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
HttpSession userSession = request.getSession(false);
if(userSession == null || userSession.getAttribute("user") == null) {
    response.sendRedirect("Login_Servlet");
    return;
}

String userEmail = (String) request.getAttribute("userEmail");
List<Map<String,String>> transactions = (List<Map<String,String>>) request.getAttribute("transactions");
if(transactions == null) transactions = new ArrayList<>();
String displayName = (userEmail != null) ? userEmail.split("@")[0] : "User";
double totalIncome = request.getAttribute("totalIncome") != null ? (Double) request.getAttribute("totalIncome") : 0;
double totalExpense = request.getAttribute("totalExpense") != null ? (Double) request.getAttribute("totalExpense") : 0;
double balance = totalIncome - totalExpense;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BankingApp — Transactions</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap');
*{margin:0;padding:0;box-sizing:border-box}
:root{--bg:#0a0a12;--s1:#12121f;--s2:#1a1a2e;--s3:#22223b;--p:#a78bfa;--p2:#38bdf8;--p3:#fb7185;--p4:#34d399;--p5:#fbbf24;--t:#f1f0ff;--m:#9998bb;--b:#ffffff18;}
body{background:var(--bg);color:var(--t);font-family:'Outfit',sans-serif;display:flex;height:100vh;overflow:hidden;font-size:13px}

/* SIDEBAR */
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

/* MAIN */
.main{flex:1;display:flex;flex-direction:column;overflow:hidden}
.topbar{display:flex;align-items:center;justify-content:space-between;padding:18px 24px;border-bottom:1px solid var(--b)}
.greet{font-size:15px;font-weight:600}
.greet em{color:var(--p);font-style:normal}
.tbr{display:flex;align-items:center;gap:10px}
.avt{width:34px;height:34px;border-radius:10px;background:linear-gradient(135deg,#a78bfa,#38bdf8);display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;color:#fff;text-transform:uppercase}

.content{flex:1;overflow-y:auto;padding:20px 24px;display:flex;flex-direction:column;gap:14px}

/* STAT CARDS */
.g3{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.card{background:var(--s2);border:1px solid var(--b);border-radius:14px;padding:16px;position:relative;overflow:hidden}
.card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px}
.ca::before{background:linear-gradient(90deg,#a78bfa,#818cf8)}
.cb::before{background:linear-gradient(90deg,#34d399,#38bdf8)}
.cc::before{background:linear-gradient(90deg,#fb7185,#f43f5e)}
.clabel{font-size:10px;color:var(--m);text-transform:uppercase;letter-spacing:1px;margin-bottom:8px;font-weight:500}
.cval{font-size:24px;font-weight:700;font-family:'DM Mono',monospace;letter-spacing:-1px}
.csub{font-size:11px;margin-top:6px;color:var(--m)}
.pill{display:inline-flex;align-items:center;padding:2px 8px;border-radius:20px;font-size:10px;font-weight:600}
.pill-up{background:#34d39922;color:var(--p4)}
.pill-dn{background:#fb718522;color:var(--p3)}

/* FILTER BAR */
.filter-bar{display:flex;align-items:center;gap:10px;flex-wrap:wrap;}
.srch{background:var(--s2);border:1px solid var(--b);border-radius:10px;padding:8px 14px;color:var(--t);font-size:12px;outline:none;font-family:inherit;flex:1;min-width:180px;transition:border .2s}
.srch:focus{border-color:var(--p)}
.srch::placeholder{color:#ffffff33}
.fsel{background:var(--s2);border:1px solid var(--b);border-radius:10px;padding:8px 12px;color:var(--t);font-size:12px;font-family:inherit;outline:none;cursor:pointer;transition:border .2s}
.fsel:focus{border-color:var(--p)}
.fsel option{background:var(--s3)}
.count{font-size:11px;color:var(--m);white-space:nowrap;}
.count span{color:var(--t);font-weight:600;}

/* TABLE CARD */
.tcard{background:var(--s2);border:1px solid var(--b);border-radius:14px;overflow:hidden;position:relative;}
.tcard::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,#a78bfa,#38bdf8);}

.thead{display:grid;grid-template-columns:2fr 1fr 1fr 1.2fr 1fr;gap:12px;padding:12px 20px;border-bottom:1px solid var(--b);font-size:10px;color:var(--m);text-transform:uppercase;letter-spacing:.8px;font-weight:500;}
.tbody{max-height:calc(100vh - 360px);overflow-y:auto;}
.tbody::-webkit-scrollbar{width:3px}
.tbody::-webkit-scrollbar-thumb{background:#ffffff22;border-radius:10px}

.trow{display:grid;grid-template-columns:2fr 1fr 1fr 1.2fr 1fr;gap:12px;padding:12px 20px;border-bottom:1px solid var(--b);align-items:center;transition:background .15s;}
.trow:last-child{border-bottom:none}
.trow:hover{background:#ffffff05}

.tx-cat{display:flex;align-items:center;gap:10px;}
.txico{width:32px;height:32px;border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;flex-shrink:0;font-family:'DM Mono',monospace}
.txn{font-size:13px;font-weight:500;text-transform:capitalize}
.txdesc{font-size:10px;color:var(--m);margin-top:1px;max-width:140px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}

.tbadge{display:inline-flex;align-items:center;padding:3px 9px;border-radius:20px;font-size:10px;font-weight:600;text-transform:capitalize;}
.tbadge.income{background:#34d39918;color:var(--p4);border:1px solid #34d39933}
.tbadge.expense{background:#fb718518;color:var(--p3);border:1px solid #fb718533}

.tdate{font-size:11px;color:var(--m);font-family:'DM Mono',monospace}
.tamt{font-size:13px;font-weight:600;font-family:'DM Mono',monospace;text-align:right}
.tamt.inc{color:var(--p4)}.tamt.exp{color:var(--p3)}

.empty{color:var(--m);font-size:12px;text-align:center;padding:40px 0}

.tcell-right{text-align:right}
</style>
</head>
<body>

<div class="sidebar">
  <div class="logo"><span class="l1">III</span> <span class="l2">BANK</span></div>
  <div class="nav">
    <a class="ni" href="Dashboard_Servlet">
      <svg viewBox="0 0 16 16" fill="none"><rect x="1" y="1" width="6" height="6" rx="1.5" fill="currentColor"/><rect x="9" y="1" width="6" height="6" rx="1.5" fill="currentColor" opacity=".5"/><rect x="1" y="9" width="6" height="6" rx="1.5" fill="currentColor" opacity=".5"/><rect x="9" y="9" width="6" height="6" rx="1.5" fill="currentColor" opacity=".5"/></svg>
      Analytics
    </a>
    <a class="ni on" href="Transactions_Servlet">
      <svg viewBox="0 0 16 16" fill="none"><path d="M2 4h12M2 8h8M2 12h5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
      Transactions
    </a>
    <div class="ndiv"></div>
    <a class="ni" href="#" style="color:var(--m)">
      <svg viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="2" stroke="currentColor" stroke-width="1.5"/><path d="M8 1v2M8 13v2M1 8h2M13 8h2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
      Settings
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
    <div class="greet">Transactions, <em><%= displayName %></em> — full history</div>
    <div class="tbr">
      <div class="avt"><%= displayName.substring(0,1).toUpperCase() %></div>
    </div>
  </div>

  <div class="content">

    <!-- STAT CARDS -->
    <div class="g3">
      <div class="card ca">
        <div class="clabel">Balance</div>
        <div class="cval">$<%= String.format("%.2f", balance) %></div>
        <div class="csub"><span class="pill <%= balance>=0?"pill-up":"pill-dn" %>"><%= balance>=0?"positive":"negative" %></span></div>
      </div>
      <div class="card cb">
        <div class="clabel">Total Income</div>
        <div class="cval">$<%= String.format("%.2f", totalIncome) %></div>
        <div class="csub"><span class="pill pill-up">all time</span></div>
      </div>
      <div class="card cc">
        <div class="clabel">Total Expenses</div>
        <div class="cval">$<%= String.format("%.2f", totalExpense) %></div>
        <div class="csub"><span class="pill pill-dn">all time</span></div>
      </div>
    </div>

    <!-- FILTER BAR -->
    <div class="filter-bar">
      <input class="srch" id="searchInput" type="text" placeholder="Search by category or note...">
      <select class="fsel" id="typeFilter">
        <option value="all">All Types</option>
        <option value="income">Income</option>
        <option value="expense">Expense</option>
      </select>
      <select class="fsel" id="sortFilter">
        <option value="date-desc">Newest First</option>
        <option value="date-asc">Oldest First</option>
        <option value="amount-desc">Highest Amount</option>
        <option value="amount-asc">Lowest Amount</option>
      </select>
      <div class="count">Showing <span id="rowCount"><%= transactions.size() %></span> transactions</div>
    </div>

    <!-- TRANSACTIONS TABLE -->
    <div class="tcard">
      <div class="thead">
        <div>Category / Note</div>
        <div>Type</div>
        <div>Date</div>
        <div class="tcell-right">Amount</div>
        <div class="tcell-right">Balance Impact</div>
      </div>
      <div class="tbody" id="txBody">
        <% if(transactions.isEmpty()) { %>
          <div class="empty">No transactions yet — add one from the dashboard!</div>
        <% } else {
          double running = balance;
          for(Map<String,String> tx : transactions) {
            boolean isIncome = "income".equals(tx.get("type"));
            double amt = Double.parseDouble(tx.get("amount"));
        %>
          <div class="trow"
               data-type="<%= tx.get("type") %>"
               data-category="<%= tx.get("category").toLowerCase() %>"
               data-desc="<%= tx.get("description").toLowerCase() %>"
               data-amount="<%= amt %>"
               data-date="<%= tx.get("date") %>">
            <div class="tx-cat">
              <div class="txico" style="background:<%= isIncome?"#34d39922":"#fb718522" %>;color:<%= isIncome?"#34d399":"#fb7185" %>">
                <%= isIncome?"+":"-" %>
              </div>
              <div>
                <div class="txn"><%= tx.get("category") %></div>
                <% if(tx.get("description") != null && !tx.get("description").isEmpty()) { %>
                  <div class="txdesc"><%= tx.get("description") %></div>
                <% } %>
              </div>
            </div>
            <div><span class="tbadge <%= tx.get("type") %>"><%= tx.get("type") %></span></div>
            <div class="tdate"><%= tx.get("date") %></div>
            <div class="tamt <%= isIncome?"inc":"exp" %> tcell-right">
              <%= isIncome?"+":"-" %>$<%= String.format("%.2f", amt) %>
            </div>
            <div class="tamt tcell-right" style="color:var(--m);font-size:11px">
              $<%= String.format("%.2f", running) %>
              <% if(isIncome) { running -= amt; } else { running += amt; } %>
            </div>
          </div>
        <% } } %>
      </div>
    </div>

  </div>
</div>

<script>
const searchInput = document.getElementById('searchInput');
const typeFilter  = document.getElementById('typeFilter');
const sortFilter  = document.getElementById('sortFilter');
const rowCount    = document.getElementById('rowCount');

function filterRows() {
  const q    = searchInput.value.toLowerCase();
  const type = typeFilter.value;
  const rows = Array.from(document.querySelectorAll('.trow'));

  let visible = rows.filter(r => {
    const matchType = type === 'all' || r.dataset.type === type;
    const matchQ    = !q || r.dataset.category.includes(q) || r.dataset.desc.includes(q);
    r.style.display = (matchType && matchQ) ? '' : 'none';
    return matchType && matchQ;
  });

  // Sort
  const sort  = sortFilter.value;
  const tbody = document.getElementById('txBody');
  visible.sort((a, b) => {
    if (sort === 'date-desc') return b.dataset.date.localeCompare(a.dataset.date);
    if (sort === 'date-asc')  return a.dataset.date.localeCompare(b.dataset.date);
    if (sort === 'amount-desc') return parseFloat(b.dataset.amount) - parseFloat(a.dataset.amount);
    if (sort === 'amount-asc')  return parseFloat(a.dataset.amount) - parseFloat(b.dataset.amount);
  });
  visible.forEach(r => tbody.appendChild(r));

  rowCount.textContent = visible.length;
}

searchInput.addEventListener('input', filterRows);
typeFilter.addEventListener('change', filterRows);
sortFilter.addEventListener('change', filterRows);
</script>
</body>
</html>
