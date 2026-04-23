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
<title>BankingApp — Login</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap');
*{margin:0;padding:0;box-sizing:border-box}
:root{--bg:#0a0a12;--s1:#12121f;--s2:#1a1a2e;--s3:#22223b;--p:#a78bfa;--p2:#38bdf8;--p3:#fb7185;--p4:#34d399;--t:#f1f0ff;--m:#9998bb;--b:#ffffff18;}
body{background:var(--bg);color:var(--t);font-family:'Outfit',sans-serif;min-height:100vh;display:flex;align-items:center;justify-content:center;font-size:13px;position:relative;overflow:hidden;}

/* Background grid effect */
body::before{content:'';position:fixed;inset:0;background-image:linear-gradient(var(--b) 1px,transparent 1px),linear-gradient(90deg,var(--b) 1px,transparent 1px);background-size:40px 40px;pointer-events:none;opacity:.4;}

/* Glow orbs */
.orb{position:fixed;border-radius:50%;filter:blur(80px);pointer-events:none;opacity:.15;}
.orb1{width:400px;height:400px;background:#a78bfa;top:-100px;right:-100px;}
.orb2{width:300px;height:300px;background:#38bdf8;bottom:-80px;left:-80px;}

.card{background:var(--s1);border:1px solid var(--b);border-radius:20px;padding:40px;width:100%;max-width:400px;position:relative;z-index:1;}
.card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;border-radius:20px 20px 0 0;background:linear-gradient(90deg,#a78bfa,#38bdf8);}

.logo{text-align:center;margin-bottom:32px;}
.logo-text{font-size:26px;font-weight:700;letter-spacing:3px;}
.logo-text .l1{color:var(--p)}.logo-text .l2{color:var(--p2)}
.logo-sub{font-size:11px;color:var(--m);margin-top:6px;letter-spacing:1px;text-transform:uppercase;}

.title{font-size:20px;font-weight:600;margin-bottom:4px;}
.subtitle{font-size:12px;color:var(--m);margin-bottom:28px;}

.fg{display:flex;flex-direction:column;gap:5px;margin-bottom:14px;}
.fl{font-size:10px;color:var(--m);text-transform:uppercase;letter-spacing:.8px;font-weight:500;}
.fi-wrap{position:relative;}
.fi{background:var(--s2);border:1px solid var(--b);border-radius:10px;padding:10px 14px;color:var(--t);font-size:13px;font-family:inherit;outline:none;width:100%;transition:border .2s,background .2s;}
.fi:focus{border-color:var(--p);background:var(--s3);}
.fi::placeholder{color:#ffffff33;}

.btn{width:100%;background:linear-gradient(135deg,#a78bfa,#818cf8);border:none;border-radius:10px;padding:12px;color:#fff;font-size:13px;font-weight:600;cursor:pointer;font-family:inherit;letter-spacing:.3px;transition:opacity .2s,transform .1s;margin-top:8px;}
.btn:hover{opacity:.9;}
.btn:active{transform:scale(.99);}

.divider{display:flex;align-items:center;gap:10px;margin:20px 0;color:var(--m);font-size:11px;}
.divider::before,.divider::after{content:'';flex:1;height:1px;background:var(--b);}

.link-row{text-align:center;font-size:12px;color:var(--m);}
.link-row a{color:var(--p);text-decoration:none;font-weight:500;}
.link-row a:hover{text-decoration:underline;}

.error{background:#fb718520;border:1px solid #fb718544;color:var(--p3);border-radius:8px;padding:9px 12px;font-size:12px;margin-bottom:16px;}
.success{background:#34d39920;border:1px solid #34d39944;color:var(--p4);border-radius:8px;padding:9px 12px;font-size:12px;margin-bottom:16px;}

.badge{display:inline-flex;align-items:center;gap:5px;background:var(--s2);border:1px solid var(--b);border-radius:20px;padding:4px 10px;font-size:10px;color:var(--m);margin-bottom:20px;}
.badge-dot{width:6px;height:6px;border-radius:50%;background:var(--p4);animation:pulse 2s infinite;}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.3}}
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

  <div class="badge"><div class="badge-dot"></div>Secure Login</div>

  <div class="title">Welcome back</div>
  <div class="subtitle">Sign in to your account to continue</div>

  <% if(msg != null) { %>
    <div class="<%= msg.contains("saved") || msg.contains("success") ? "success" : "error" %>"><%= msg %></div>
  <% } %>

  <form method="POST" action="Login_Servlet">
    <div class="fg">
      <div class="fl">Email Address</div>
      <div class="fi-wrap">
        <input class="fi" type="email" name="email" placeholder="you@example.com" required>
      </div>
    </div>
    <div class="fg">
      <div class="fl">Password</div>
      <div class="fi-wrap">
        <input class="fi" type="text" name="password" placeholder="••••••••" required>
      </div>
    </div>
    <button class="btn" type="submit">Sign In →</button>
  </form>

  <div class="divider">or</div>

  <div class="link-row">Don't have an account? <a href="Register_Servlet">Create one</a></div>
</div>
</body>
</html>
