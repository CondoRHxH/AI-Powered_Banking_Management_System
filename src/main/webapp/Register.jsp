<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
HttpSession userSession = request.getSession(false);
if(userSession != null && userSession.getAttribute("user") != null) {
    response.sendRedirect("Dashboard_Servlet");
    return;
}
String msg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BankingApp — Register</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap');
*{margin:0;padding:0;box-sizing:border-box}
:root{--bg:#0a0a12;--s1:#12121f;--s2:#1a1a2e;--s3:#22223b;--p:#a78bfa;--p2:#38bdf8;--p3:#fb7185;--p4:#34d399;--t:#f1f0ff;--m:#9998bb;--b:#ffffff18;}
body{background:var(--bg);color:var(--t);font-family:'Outfit',sans-serif;min-height:100vh;display:flex;align-items:center;justify-content:center;font-size:13px;position:relative;overflow:hidden;padding:20px 0;}

body::before{content:'';position:fixed;inset:0;background-image:linear-gradient(var(--b) 1px,transparent 1px),linear-gradient(90deg,var(--b) 1px,transparent 1px);background-size:40px 40px;pointer-events:none;opacity:.4;}

.orb{position:fixed;border-radius:50%;filter:blur(80px);pointer-events:none;opacity:.15;}
.orb1{width:400px;height:400px;background:#38bdf8;top:-100px;left:-100px;}
.orb2{width:300px;height:300px;background:#a78bfa;bottom:-80px;right:-80px;}

.card{background:var(--s1);border:1px solid var(--b);border-radius:20px;padding:40px;width:100%;max-width:420px;position:relative;z-index:1;}
.card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;border-radius:20px 20px 0 0;background:linear-gradient(90deg,#38bdf8,#a78bfa);}

.logo{text-align:center;margin-bottom:28px;}
.logo-text{font-size:26px;font-weight:700;letter-spacing:3px;}
.logo-text .l1{color:var(--p)}.logo-text .l2{color:var(--p2)}
.logo-sub{font-size:11px;color:var(--m);margin-top:6px;letter-spacing:1px;text-transform:uppercase;}

.title{font-size:20px;font-weight:600;margin-bottom:4px;}
.subtitle{font-size:12px;color:var(--m);margin-bottom:24px;}

.fgrid{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
.fg{display:flex;flex-direction:column;gap:5px;margin-bottom:14px;}
.fg.full{grid-column:1/-1;margin-bottom:0;}
.fl{font-size:10px;color:var(--m);text-transform:uppercase;letter-spacing:.8px;font-weight:500;}
.fi{background:var(--s2);border:1px solid var(--b);border-radius:10px;padding:10px 14px;color:var(--t);font-size:13px;font-family:inherit;outline:none;width:100%;transition:border .2s,background .2s;}
.fi:focus{border-color:var(--p2);background:var(--s3);}
.fi::placeholder{color:#ffffff33;}

.btn{width:100%;background:linear-gradient(135deg,#38bdf8,#818cf8);border:none;border-radius:10px;padding:12px;color:#fff;font-size:13px;font-weight:600;cursor:pointer;font-family:inherit;letter-spacing:.3px;transition:opacity .2s,transform .1s;margin-top:18px;}
.btn:hover{opacity:.9;}
.btn:active{transform:scale(.99);}

.divider{display:flex;align-items:center;gap:10px;margin:20px 0;color:var(--m);font-size:11px;}
.divider::before,.divider::after{content:'';flex:1;height:1px;background:var(--b);}

.link-row{text-align:center;font-size:12px;color:var(--m);}
.link-row a{color:var(--p2);text-decoration:none;font-weight:500;}
.link-row a:hover{text-decoration:underline;}

.error{background:#fb718520;border:1px solid #fb718544;color:var(--p3);border-radius:8px;padding:9px 12px;font-size:12px;margin-bottom:16px;}
.success{background:#34d39920;border:1px solid #34d39944;color:var(--p4);border-radius:8px;padding:9px 12px;font-size:12px;margin-bottom:16px;}

.perks{display:flex;gap:8px;margin-bottom:24px;flex-wrap:wrap;}
.perk{display:inline-flex;align-items:center;gap:4px;background:var(--s2);border:1px solid var(--b);border-radius:20px;padding:4px 10px;font-size:10px;color:var(--m);}
.perk span{color:var(--p4);}
</style>
</head>
<body>
<div class="orb orb1"></div>
<div class="orb orb2"></div>

<div class="card">
  <div class="logo">
    <div class="logo-text"><span class="l1">III</span> <span class="l2">BANK</span></div>
    <div class="logo-sub">Personal Finance Manager</div>
  </div>

  <div class="perks">
    <div class="perk"><span>✓</span> Free forever</div>
    <div class="perk"><span>✓</span> AI advisor</div>
    <div class="perk"><span>✓</span> Secure</div>
  </div>

  <div class="title">Create account</div>
  <div class="subtitle">Start tracking your finances in seconds</div>

  <% if(msg != null) { %>
    <div class="<%= msg.contains("success") || msg.contains("created") ? "success" : "error" %>"><%= msg %></div>
  <% } %>

  <form method="POST" action="Register_Servlet">
    <div class="fgrid">
      <div class="fg">
        <div class="fl">First Name</div>
        <input class="fi" type="text" name="prenom" placeholder="John" required>
      </div>
      <div class="fg">
        <div class="fl">Last Name</div>
        <input class="fi" type="text" name="nom" placeholder="Doe" required>
      </div>
    </div>
    <div class="fg">
      <div class="fl">Email Address</div>
      <input class="fi" type="email" name="email" placeholder="you@example.com" required>
    </div>
    <div class="fg">
      <div class="fl">Password</div>
      <input class="fi" type="text" name="password" placeholder="••••••••" required>
    </div>
    <button class="btn" type="submit">Create Account →</button>
  </form>

  <div class="divider">or</div>

  <div class="link-row">Already have an account? <a href="Login_Servlet">Sign in</a></div>
</div>
</body>
</html>
