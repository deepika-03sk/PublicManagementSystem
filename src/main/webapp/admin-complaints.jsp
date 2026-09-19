<%@ **page** contentType=*"text/html; charset=UTF-8"* pageEncoding=*"UTF-8"* %>

<%@ **page** import=*"java.sql.\*"* %>

<%

    // ==========================================

    // LOGIN PROTECTION

    // ==========================================

    if (session.getAttribute("userId") == null) {

        response.sendRedirect("index.jsp");

        return;

    }

    // ==========================================

    // ADMIN PROTECTION

    // ==========================================

    String currentRole =

        (String) session.getAttribute("role");

    if (!"ADMIN".equals(currentRole)) {

        response.sendRedirect("dashboard.jsp");

        return;

    }



    // ==========================================

    // SEARCH / FILTER VALUES

    // ==========================================

    String search =

        request.getParameter("search");

    String statusFilter =

        request.getParameter("status");

    String categoryFilter =

        request.getParameter("category");



    if (search == null) {

        search = "";

    }

    if (statusFilter == null) {

        statusFilter = "";

    }

    if (categoryFilter == null) {

        categoryFilter = "";

    }

%>



\<!**DOCTYPE** html>

<**html** lang=*"en"*>

<**head**>

    <**meta** charset=*"UTF-8"*>

    <**meta** name=*"viewport"*

          content=*"width=device-width, initial-scale=1.0"*>

    <**title**>Complaint Management\</**title**>

    <**link** rel=*"stylesheet"* href=*"style.css"*>

    <**style**>

        .complaint-header {

            margin-bottom: *25px*;

        }

        .complaint-header h1 {

            background: *none*;

            padding: *0*;

            color: *#0f172a*;

            margin-bottom: *8px*;

        }

        .complaint-header p {

            color: *#64748b*;

        }



        /\* ================================

           FILTER BOX

           \================================ \*/

        .filter-box {

            background: *white*;

            padding: *25px*;

            border-radius: *18px*;

            margin-bottom: *25px*;

            box-shadow:

                *0 8px 25px*

                *rgba(15, 23, 42, 0.08)*;

        }



        .filter-title {

            font-size: *18px*;

            font-weight: *700*;

            color: *#0f172a*;

            margin-bottom: *18px*;

        }



        .filter-form {

            display: *grid*;

            grid-template-columns:

                *2fr 1fr 1fr auto*;

            gap: *12px*;

            align-items: *end*;

        }



        .filter-field label {

            display: *block*;

            font-size: *13px*;

            font-weight: *600*;

            color: *#475569*;

            margin-bottom: *7px*;

        }



        .filter-field input,

        .filter-field select {

            width: *100%*;

            box-sizing: *border-box*;

        }



        .filter-button {

            padding: *12px 20px*;

            border: *none*;

            border-radius: *9px*;

            background: *#2563eb*;

            color: *white*;

            font-weight: *600*;

            cursor: *pointer*;

        }



        .filter-button\:hover {

            background: *#1d4ed8*;

        }



        .clear-button {

            display: *inline-flex*;

            align-items: *center*;

            justify-content: *center*;

            margin-top: *12px*;

            padding: *9px 15px*;

            border-radius: *8px*;

            background: *#e2e8f0*;

            color: *#334155*;

            text-decoration: *none*;

            font-size: *14px*;

            font-weight: *600*;

        }



        .clear-button\:hover {

            background: *#cbd5e1*;

        }



        /\* ================================

           STATUS

           \================================ \*/

        .status-badge {

            display: *inline-block*;

            padding: *6px 11px*;

            border-radius: *20px*;

            font-size: *12px*;

            font-weight: *700*;

            white-space: *nowrap*;

        }



        .pending {

            background: *#fef3c7*;

            color: *#92400e*;

        }



        .progress {

            background: *#dbeafe*;

            color: *#1e40af*;

        }



        .resolved {

            background: *#dcfce7*;

            color: *#166534*;

        }



        .rejected {

            background: *#fee2e2*;

            color: *#991b1b*;

        }



        /\* ================================

           PRIORITY

           \================================ \*/

        .priority-high {

            color: *#dc2626*;

            font-weight: *700*;

        }



        .priority-medium {

            color: *#d97706*;

            font-weight: *700*;

        }



        .priority-low {

            color: *#16a34a*;

            font-weight: *700*;

        }



        /\* ================================

           ACTION BUTTON

           \================================ \*/

        .action-edit {

            display: *inline-block*;

            padding: *7px 12px*;

            border-radius: *8px*;

            background: *#eff6ff*;

            color: *#1d4ed8*;

            text-decoration: *none*;

            font-size: *13px*;

            font-weight: *600*;

        }



        .action-edit\:hover {

            background: *#dbeafe*;

        }



        .no-data {

            text-align: *center*;

            padding: *50px*;

        }



        .no-data-icon {

            font-size: *55px*;

            margin-bottom: *15px*;

        }



        /\* ================================

           MOBILE

           \================================ \*/

        @media (max-width: 900px) {

            .filter-form {

                grid-template-columns: *1fr 1fr*;

            }

        }



        @media (max-width: 600px) {

            .filter-form {

                grid-template-columns: *1fr*;

            }

        }

    \</**style**>

\</**head**>



<**body**>



\<!-- ==========================================

     NAVIGATION

     \========================================== -->

<**nav** class=*"navbar"*>

    <**div** class=*"logo"*>

        🏛️ Public Management System

    \</**div**>



    <**div** class=*"nav-links"*>

        <**a** href=*"dashboard.jsp"*>

            🏠 Dashboard

        \</**a**>

        <**a** href=*"users.jsp"*>

            👥 Users

        \</**a**>

        <**a** href=*"admin-complaints.jsp"*>

            📋 Complaints

        \</**a**>

        <**a** href=*"logout"*>

            🚪 Logout

        \</**a**>

    \</**div**>

\</**nav**>



\<!-- ==========================================

     MAIN

     \========================================== -->

<**div** class=*"container"*>



    <**div** class=*"complaint-header"*>

        <**h1** class=*"page-title"*>

            📋 Complaint Management

        \</**h1**>

        <**p**>

            Review, search and manage

            citizen complaints.

        \</**p**>

        <**br**>

        <**a** class=*"back-link"*

           href=*"dashboard.jsp"*>

            ← Back to Dashboard

        \</**a**>

    \</**div**>





    \<!-- ======================================

         SEARCH AND FILTER

         \====================================== -->

    <**div** class=*"filter-box"*>



        <**div** class=*"filter-title"*>

            🔍 Search & Filter Complaints

        \</**div**>



        <**form**

            method=*"get"*

            action=*"admin-complaints.jsp"*

            class=*"filter-form"*>



            \<!-- SEARCH -->

            <**div** class=*"filter-field"*>

                <**label** for=*"search"*>

                    🔍 Search

                \</**label**>

                <**input**

                    type=*"text"*

                    id=*"search"*

                    name=*"search"*

                    value=*"*<%= search %>*"*

                    placeholder=*"Citizen, email, title or location"*>

            \</**div**>



            \<!-- STATUS -->

            <**div** class=*"filter-field"*>

                <**label** for=*"status"*>

                    🔄 Status

                \</**label**>

                <**select**

                    id=*"status"*

                    name=*"status"*>

                    <**option** value=*""*>

                        All Status

                    \</**option**>

                    <**option**

                        value=*"PENDING"*

                        <%= "PENDING".equals(statusFilter)

                            ? "selected" : "" %>>

                        🟡 Pending

                    \</**option**>

                    <**option**

                        value=*"IN_PROGRESS"*

                        <%= "IN_PROGRESS".equals(statusFilter)

                            ? "selected" : "" %>>

                        🔵 In Progress

                    \</**option**>

                    <**option**

                        value=*"RESOLVED"*

                        <%= "RESOLVED".equals(statusFilter)

                            ? "selected" : "" %>>

                        🟢 Resolved

                    \</**option**>

                    <**option**

                        value=*"REJECTED"*

                        <%= "REJECTED".equals(statusFilter)

                            ? "selected" : "" %>>

                        🔴 Rejected

                    \</**option**>

                \</**select**>

            \</**div**>



            \<!-- CATEGORY -->

            <**div** class=*"filter-field"*>

                <**label** for=*"category"*>

                    📂 Category

                \</**label**>

                <**select**

                    id=*"category"*

                    name=*"category"*>

                    <**option** value=*""*>

                        All Categories

                    \</**option**>

                    <**option**

                        value=*"ROADS"*

                        <%= "ROADS".equals(categoryFilter)

                            ? "selected" : "" %>>

                        🛣️ Roads

                    \</**option**>

                    <**option**

                        value=*"ELECTRICITY"*

                        <%= "ELECTRICITY".equals(categoryFilter)

                            ? "selected" : "" %>>

                        💡 Electricity

                    \</**option**>

                    <**option**

                        value=*"WATER"*

                        <%= "WATER".equals(categoryFilter)

                            ? "selected" : "" %>>

                        💧 Water

                    \</**option**>

                    <**option**

                        value=*"SANITATION"*

                        <%= "SANITATION".equals(categoryFilter)

                            ? "selected" : "" %>>

                        🗑️ Sanitation

                    \</**option**>

                    <**option**

                        value=*"STREET_LIGHT"*

                        <%= "STREET_LIGHT".equals(categoryFilter)

                            ? "selected" : "" %>>

                        🔦 Street Lights

                    \</**option**>

                    <**option**

                        value=*"PUBLIC_SAFETY"*

                        <%= "PUBLIC_SAFETY".equals(categoryFilter)

                            ? "selected" : "" %>>

                        🛡️ Public Safety

                    \</**option**>

                    <**option**

                        value=*"OTHER"*

                        <%= "OTHER".equals(categoryFilter)

                            ? "selected" : "" %>>

                        📌 Other

                    \</**option**>

                \</**select**>

            \</**div**>



            \<!-- SEARCH BUTTON -->

            <**div**>

                <**button**

                    type=*"submit"*

                    class=*"filter-button"*>

                    🔎 Search

                \</**button**>

            \</**div**>



        \</**form**>



        <**a**

            href=*"admin-complaints.jsp"*

            class=*"clear-button"*>

            ✖️ Clear Filters

        \</**a**>



    \</**div**>





    \<!-- ======================================

         COMPLAINT TABLE

         \====================================== -->

    <**div** class=*"table-container"*>

        <**table**>



            <**thead**>

                <**tr**>

                    <**th**>No.\</**th**>

                    <**th**>Citizen\</**th**>

                    <**th**>Complaint\</**th**>

                    <**th**>Category\</**th**>

                    <**th**>Location\</**th**>

                    <**th**>Priority\</**th**>

                    <**th**>Status\</**th**>

                    <**th**>Date\</**th**>

                    <**th**>Action\</**th**>

                \</**tr**>

            \</**thead**>



            <**tbody**>



<%

try {

        Class.forName(

            "com.mysql.cj.jdbc.Driver"

        );



        Connection con = DBConnection.getConnection();

        /\*

         \* =====================================

         \* DYNAMIC QUERY

         \* =====================================

         \*/

        StringBuilder sql =

            new StringBuilder(

                "SELECT c.id, c.title, c.category, " +

                "c.location, c.priority, c.status, " +

                "c.created_at, " +

                "u.first_name, u.last_name, u.email " +

                "FROM complaints c " +

                "JOIN users u ON c.user_id = u.id " +

                "WHERE 1=1 "

            );



        /\*

         \* Search condition

         \*/

        if (!search.trim().isEmpty()) {

            sql.append(

                "AND (" +

                "u.first_name LIKE ? OR " +

                "u.last_name LIKE ? OR " +

                "u.email LIKE ? OR " +

                "c.title LIKE ? OR " +

                "c.location LIKE ?" +

                ") "

            );

        }



        /\*

         \* Status filter

         \*/

        if (!statusFilter.trim().isEmpty()) {

            sql.append(

                "AND c.status = ? "

            );

        }



        /\*

         \* Category filter

         \*/

        if (!categoryFilter.trim().isEmpty()) {

            sql.append(

                "AND c.category = ? "

            );

        }



        sql.append(

            "ORDER BY c.id ASC"

        );



        PreparedStatement ps =

            con.prepareStatement(

                sql.toString()

            );



        int parameterIndex = 1;



        /\*

         \* Search parameters

         \*/

        if (!search.trim().isEmpty()) {

            String searchValue =

                "%" + search.trim() + "%";



            ps.setString(

                parameterIndex++,

                searchValue

            );

            ps.setString(

                parameterIndex++,

                searchValue

            );

            ps.setString(

                parameterIndex++,

                searchValue

            );

            ps.setString(

                parameterIndex++,

                searchValue

            );

            ps.setString(

                parameterIndex++,

                searchValue

            );

        }



        /\*

         \* Status parameter

         \*/

        if (!statusFilter.trim().isEmpty()) {

            ps.setString(

                parameterIndex++,

                statusFilter

            );

        }



        /\*

         \* Category parameter

         \*/

        if (!categoryFilter.trim().isEmpty()) {

            ps.setString(

                parameterIndex++,

                categoryFilter

            );

        }



        ResultSet rs =

            ps.executeQuery();



        int displayNumber = 1;

        boolean found = false;



        while (rs.next()) {

            found = true;

            String status =

                rs.getString("status");

            String priority =

                rs.getString("priority");

%>



                <**tr**>



                    \<!-- NUMBER -->

                    <**td**>

                        <**strong**>

                            <%= displayNumber %>

                        \</**strong**>

                    \</**td**>



                    \<!-- CITIZEN -->

                    <**td**>

                        👤

                        <%= rs.getString("first_name") %>

                        <%= rs.getString("last_name") %>

                        <**br**>

                        <**small**>

                            📧

                            <%= rs.getString("email") %>

                        \</**small**>

                    \</**td**>



                    \<!-- COMPLAINT -->

                    <**td**>

                        📝

                        <**strong**>

                            <%= rs.getString("title") %>

                        \</**strong**>

                    \</**td**>



                    \<!-- CATEGORY -->

                    <**td**>

                        📂

                        <%= rs.getString("category") %>

                    \</**td**>



                    \<!-- LOCATION -->

                    <**td**>

                        📍

                        <%= rs.getString("location") %>

                    \</**td**>



                    \<!-- PRIORITY -->

                    <**td**>

<%

                    if ("HIGH".equals(priority)) {

%>

                        <**span** class=*"priority-high"*>

                            🔴 HIGH

                        \</**span**>

<%

                    } else if ("MEDIUM".equals(priority)) {

%>

                        <**span** class=*"priority-medium"*>

                            🟡 MEDIUM

                        \</**span**>

<%

                    } else {

%>

                        <**span** class=*"priority-low"*>

                            🟢 LOW

                        \</**span**>

<%

                    }

%>

                    \</**td**>



                    \<!-- STATUS -->

                    <**td**>

<%

                    if ("PENDING".equals(status)) {

%>

                        <**span** class=*"status-badge pending"*>

                            🟡 PENDING

                        \</**span**>

<%

                    } else if ("IN_PROGRESS".equals(status)) {

%>

                        <**span** class=*"status-badge progress"*>

                            🔵 IN PROGRESS

                        \</**span**>

<%

                    } else if ("RESOLVED".equals(status)) {

%>

                        <**span** class=*"status-badge resolved"*>

                            🟢 RESOLVED

                        \</**span**>

<%

                    } else if ("REJECTED".equals(status)) {

%>

                        <**span** class=*"status-badge rejected"*>

                            🔴 REJECTED

                        \</**span**>

<%

                    } else {

%>

                        <%= status %>

<%

                    }

%>

                    \</**td**>



                    \<!-- DATE -->

                    <**td**>

                        <%= rs.getTimestamp("created_at") %>

                    \</**td**>



                    \<!-- ACTION -->

                    <**td**>

                            <**a**

                                    class=*"action-edit"*

                                    href=*"complaint-details.jsp?id=*<%= rs.getInt("id") %>*"*>

                                    👀 View

                            \</**a**>

                    \</**td**>



                \</**tr**>



<%

            displayNumber++;

        }



        /\*

         \* =====================================

         \* NO RESULTS

         \* =====================================

         \*/

        if (!found) {

%>



                <**tr**>

                    <**td** colspan=*"9"*>

                        <**div** class=*"no-data"*>

                            <**div** class=*"no-data-icon"*>

                                🔍

                            \</**div**>

                            <**h2**>

                                No Complaints Found

                            \</**h2**>

                            <**p**>

                                Try changing your

                                search or filters.

                            \</**p**>

                        \</**div**>

                    \</**td**>

                \</**tr**>



<%

        }



        rs.close();

        ps.close();

        con.close();



    } catch (Exception e) {

%>



                <**tr**>

                    <**td**

                        colspan=*"9"*

                        style="color:*red*;

                               padding:*20px*;">

                        ⚠️ Database Error:

                        <%= e.getMessage() %>

                    \</**td**>

                \</**tr**>



<%

    }

%>



            \</**tbody**>

        \</**table**>

    \</**div**>



\</**div**>



\</**body**>

\</**html**>