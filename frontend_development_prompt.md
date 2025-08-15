# 🎯 **JSP Frontend Development Prompt (Pure JSP + HTML/CSS/JS)**

> You are a senior web developer building a modern, responsive **JSP-based frontend** for the **"Parent-First Academic Center Management System"** using **JSP pages, HTML5, CSS3, and Vanilla JavaScript** — no Java classes, servlets, or frameworks.
>
> The system prioritizes **parental access** to academic data with a clean, professional, mobile-first interface that leverages JSP's templating capabilities for dynamic content rendering.

---

## 📁 **Project Structure (JSP-Focused)**

```
/webapp
  ├── index.jsp                    (Dashboard/Home - main entry point)
  ├── student-profile.jsp
  ├── view-grades.jsp
  ├── view-attendance.jsp
  ├── messages.jsp
  ├── announcements.jsp
  ├── class-schedule.jsp
  ├── teacher-list.jsp
  ├── course-management.jsp
  ├── includes/
  │   ├── header.jsp              (Reusable header with navigation)
  │   ├── sidebar.jsp             (Navigation sidebar)
  │   ├── footer.jsp              (Common footer)
  │   └── meta.jsp                (Common meta tags, CSS/JS includes)
  ├── css/
  │   ├── style.css               (Main stylesheet with CSS variables)
  │   └── responsive.css          (Media queries)
  ├── js/
  │   ├── main.js                 (Global scripts)
  │   └── components.js           (Reusable JS components)
  └── assets/
      ├── images/
      └── icons/
```

---

## 🎨 **JSP Design Pattern & Templating**

### **Master Layout Structure**
Each JSP page should follow this pattern:

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="includes/meta.jsp" %>
<html lang="en">
<head>
    <title>Page Title - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <%@ include file="includes/sidebar.jsp" %>
        
        <main class="content-area">
            <!-- Page-specific content here -->
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
```

### **Dynamic Content with JSP**
Use JSP features for dynamic rendering:

- **Variables & Expressions**: `<%= studentName %>`, `${grade}`
- **Conditional Content**: 
  ```jsp
  <% if (hasNewMessages) { %>
      <span class="notification-badge">New</span>
  <% } %>
  ```
- **Loops for Data**: 
  ```jsp
  <% for (int i = 0; i < grades.length; i++) { %>
      <tr>
          <td><%= grades[i].subject %></td>
          <td><%= grades[i].score %></td>
      </tr>
  <% } %>
  ```
- **Include Parameters**: 
  ```jsp
  <jsp:include page="includes/sidebar.jsp">
      <jsp:param name="activePage" value="grades" />
  </jsp:include>
  ```

---

## 🧱 **Reusable JSP Components**

### **1. includes/meta.jsp**
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Parent-First Academic Center Management">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/responsive.css">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
```

### **2. includes/header.jsp**
Dynamic header with user context:
```jsp
<%
    String parentName = (String) session.getAttribute("parentName");
    String studentName = (String) session.getAttribute("studentName");
    boolean hasNotifications = true; // Dynamic logic here
%>

<header class="main-header">
    <div class="header-content">
        <div class="logo-section">
            <h1><i class="fas fa-graduation-cap"></i> Academic Center</h1>
        </div>
        
        <div class="header-actions">
            <% if (hasNotifications) { %>
                <div class="notification-icon">
                    <i class="fas fa-bell"></i>
                    <span class="notification-count">3</span>
                </div>
            <% } %>
            
            <div class="user-menu">
                <span class="welcome-text">Welcome, <%= parentName != null ? parentName : "Parent" %></span>
                <img src="assets/images/parent-avatar.png" alt="Parent Avatar" class="user-avatar">
            </div>
        </div>
        
        <button class="mobile-menu-toggle" id="mobileMenuToggle">
            <i class="fas fa-bars"></i>
        </button>
    </div>
</header>
```

### **3. includes/sidebar.jsp**
Navigation with active page highlighting:
```jsp
<%
    String currentPage = request.getParameter("activePage");
    if (currentPage == null) currentPage = "";
%>

<nav class="sidebar" id="sidebar">
    <ul class="nav-menu">
        <li><a href="index.jsp" class="<%= currentPage.equals("dashboard") ? "active" : "" %>">
            <i class="fas fa-home"></i> Dashboard</a></li>
        <li><a href="student-profile.jsp" class="<%= currentPage.equals("profile") ? "active" : "" %>">
            <i class="fas fa-user"></i> Student Profile</a></li>
        <li><a href="view-grades.jsp" class="<%= currentPage.equals("grades") ? "active" : "" %>">
            <i class="fas fa-chart-line"></i> View Grades</a></li>
        <li><a href="view-attendance.jsp" class="<%= currentPage.equals("attendance") ? "active" : "" %>">
            <i class="fas fa-calendar-check"></i> Attendance</a></li>
        <li><a href="messages.jsp" class="<%= currentPage.equals("messages") ? "active" : "" %>">
            <i class="fas fa-envelope"></i> Messages</a></li>
        <li><a href="announcements.jsp" class="<%= currentPage.equals("announcements") ? "active" : "" %>">
            <i class="fas fa-bullhorn"></i> Announcements</a></li>
        <li><a href="class-schedule.jsp" class="<%= currentPage.equals("schedule") ? "active" : "" %>">
            <i class="fas fa-clock"></i> Schedule</a></li>
        <li><a href="teacher-list.jsp" class="<%= currentPage.equals("teachers") ? "active" : "" %>">
            <i class="fas fa-chalkboard-teacher"></i> Teachers</a></li>
        <li><a href="course-management.jsp" class="<%= currentPage.equals("courses") ? "active" : "" %>">
            <i class="fas fa-book"></i> Courses</a></li>
    </ul>
</nav>
```

---

## 📊 **Sample Page: view-grades.jsp**

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Mock data (in real app, this would come from database/session)
    String[][] grades = {
        {"Mathematics", "A", "92%", "Fall 2024", "Mrs. Johnson"},
        {"Science", "B+", "87%", "Fall 2024", "Mr. Smith"},
        {"English", "A-", "90%", "Fall 2024", "Ms. Davis"},
        {"History", "B", "85%", "Fall 2024", "Mr. Brown"}
    };
    
    String currentTerm = "Fall 2024";
    double gpa = 3.65;
%>

<%@ include file="includes/meta.jsp" %>
<html lang="en">
<head>
    <title>View Grades - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="grades" />
        </jsp:include>
        
        <main class="content-area">
            <div class="page-header">
                <h2><i class="fas fa-chart-line"></i> Academic Grades</h2>
                <div class="term-selector">
                    <label for="termSelect">Term:</label>
                    <select id="termSelect" class="form-control">
                        <option value="fall2024" selected>Fall 2024</option>
                        <option value="spring2024">Spring 2024</option>
                        <option value="fall2023">Fall 2023</option>
                    </select>
                </div>
            </div>
            
            <!-- GPA Summary Card -->
            <div class="summary-card">
                <div class="gpa-display">
                    <span class="gpa-label">Current GPA</span>
                    <span class="gpa-value"><%= String.format("%.2f", gpa) %></span>
                </div>
                <div class="term-info">
                    <span class="term-label">Term: <%= currentTerm %></span>
                </div>
            </div>
            
            <!-- Grades Table -->
            <div class="data-table-container">
                <div class="table-header">
                    <h3>Course Grades</h3>
                </div>
                
                <div class="responsive-table">
                    <table class="grades-table">
                        <thead>
                            <tr>
                                <th>Subject</th>
                                <th>Letter Grade</th>
                                <th>Percentage</th>
                                <th>Term</th>
                                <th>Teacher</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (int i = 0; i < grades.length; i++) { %>
                                <tr class="grade-row">
                                    <td class="subject-cell">
                                        <i class="fas fa-book-open"></i>
                                        <%= grades[i][0] %>
                                    </td>
                                    <td class="grade-cell">
                                        <span class="grade-badge grade-<%= grades[i][1].toLowerCase().replaceAll("[^a-z]", "") %>">
                                            <%= grades[i][1] %>
                                        </span>
                                    </td>
                                    <td class="percentage-cell"><%= grades[i][2] %></td>
                                    <td class="term-cell"><%= grades[i][3] %></td>
                                    <td class="teacher-cell"><%= grades[i][4] %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Mobile Card View (Hidden on Desktop) -->
                <div class="mobile-cards">
                    <% for (int i = 0; i < grades.length; i++) { %>
                        <div class="grade-card">
                            <div class="card-header">
                                <h4><%= grades[i][0] %></h4>
                                <span class="grade-badge grade-<%= grades[i][1].toLowerCase().replaceAll("[^a-z]", "") %>">
                                    <%= grades[i][1] %>
                                </span>
                            </div>
                            <div class="card-body">
                                <p><strong>Percentage:</strong> <%= grades[i][2] %></p>
                                <p><strong>Teacher:</strong> <%= grades[i][4] %></p>
                                <p><strong>Term:</strong> <%= grades[i][3] %></p>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
    
    <script src="js/main.js"></script>
    <script>
        // Page-specific JavaScript
        document.getElementById('termSelect').addEventListener('change', function() {
            // Simulate filtering grades by term
            console.log('Term changed to:', this.value);
        });
    </script>
</body>
</html>
```

---

## 🎨 **CSS Architecture with JSP in Mind**

### **CSS Variables for Dynamic Theming**
```css
:root {
    --primary-color: #2c5aa0;
    --secondary-color: #17a2b8;
    --success-color: #28a745;
    --warning-color: #ffc107;
    --danger-color: #dc3545;
    --light-bg: #f8f9fa;
    --dark-text: #343a40;
    --border-color: #dee2e6;
    --shadow: 0 2px 10px rgba(0,0,0,0.1);
    --border-radius: 8px;
    --transition: all 0.3s ease;
}

/* Grade-specific styling for JSP-generated content */
.grade-badge.grade-a { background: var(--success-color); }
.grade-badge.grade-b { background: var(--primary-color); }
.grade-badge.grade-c { background: var(--warning-color); color: #000; }
.grade-badge.grade-d { background: var(--danger-color); }
```

---

## 🔧 **JavaScript Integration with JSP**

### **Passing JSP Data to JavaScript**
```jsp
<script>
    // Pass server-side data to client-side JS
    const studentData = {
        name: '<%= studentName %>',
        grades: <%= gradesJsonString %>,
        hasNewMessages: <%= hasNewMessages %>
    };
    
    // Initialize page-specific functionality
    document.addEventListener('DOMContentLoaded', function() {
        initializeGradesPage(studentData);
    });
</script>
```

---

## 📱 **Mobile-First Responsive Strategy**

- **Tables → Cards**: Use CSS `@media` queries to hide tables and show card layouts on mobile
- **Hamburger Menu**: Toggle sidebar visibility using JavaScript
- **Touch-Friendly**: Larger touch targets (44px minimum)
- **Horizontal Scroll**: For complex tables that can't be restructured

---

## 🚀 **Key Benefits of This JSP Approach**

1. **Server-Side Rendering**: Fast initial page loads
2. **Template Reusability**: DRY principle with includes
3. **Dynamic Content**: Real-time data integration
4. **SEO Friendly**: Server-rendered HTML
5. **No Framework Dependencies**: Pure JSP + standard web technologies
6. **Easy Deployment**: Standard JSP container (Tomcat, etc.)

---

## 📋 **Implementation Checklist**

- [ ] Set up JSP project structure
- [ ] Create reusable includes (header, sidebar, footer, meta)
- [ ] Build responsive CSS framework with variables
- [ ] Implement mobile navigation with JavaScript
- [ ] Create all 8 core pages with consistent templating
- [ ] Add mock data integration for dynamic content
- [ ] Test responsive behavior across devices
- [ ] Validate accessibility (ARIA labels, keyboard navigation)
- [ ] Optimize for performance (CSS/JS minification)

---

**Deliverable**: A modern, responsive, JSP-based frontend that leverages server-side templating for dynamic content while maintaining clean separation of concerns and mobile-first design principles.