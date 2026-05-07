#!/bin/bash

TOMCAT_DIR="/home/legion/Downloads/apache-tomcat-9.0.102"

# Club Management System Startup Script
echo "======================================="
echo "   Club Management System"
echo "======================================="
echo ""
echo "📋 Prerequisites:"
echo "  1. MySQL server must be running"
echo "  2. Database 'CLUB' must be created"
echo "  3. Credentials: root/root (edit src/util/DBConnection.java if needed)"
echo ""
echo "🗂️ Available URLs:"
echo "  - /login - Login page"
echo "  - /dashboard - Dashboard (requires login)"
echo "  - /users - List users (admin only)"
echo "  - /users/create - Create user (admin only)"
echo "  - /clubs - List clubs"
echo "  - /clubs/create - Create club"
echo "  - /clubs/view - View club details"
echo "  - /events - List events"
echo "  - /events/create - Create event"
echo "  - /membership - Manage memberships"
echo ""
echo "⚠️ Note:"
echo "  - There is NO '/users/view' endpoint in the project"
echo ""
echo "📦 Building project..."
mvn clean package
if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi
echo ""

PS3="Choose server to start: "
options=("Jetty (port 8081)" "Tomcat (port 8080)" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Jetty (port 8081)")
            echo ""
            echo "🚀 Starting Jetty server..."
            echo "🔗 Application URL: http://localhost:8081/clubManagement/"
            echo ""
            echo "======================================="
            echo ""
            mvn jetty:run
            break
            ;;
        "Tomcat (port 8080)")
            echo ""
            echo "📤 Deploying WAR to Tomcat..."
            if [ -d "$TOMCAT_DIR" ]; then
                cp target/clubManagement.war "$TOMCAT_DIR/webapps/"
                echo "✅ WAR file deployed!"
                
                echo "🔄 Stopping Tomcat..."
                "$TOMCAT_DIR/bin/shutdown.sh"
                sleep 3
                
                echo "🚀 Starting Tomcat..."
                "$TOMCAT_DIR/bin/startup.sh"
                echo "✅ Tomcat started!"
                echo "🔗 Application URL: http://localhost:8080/clubManagement/"
            else
                echo "❌ Tomcat directory not found: $TOMCAT_DIR"
            fi
            break
            ;;
        "Quit")
            echo "👋 Goodbye!"
            break
            ;;
        *)
            echo "❌ Invalid option $REPLY"
            ;;
    esac
done
