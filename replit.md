# CGR01-WORK

## Overview

CGR01-WORK is a full-stack web application with a clear separation between frontend and backend components. The project is designed for development in Replit with deployment to external hosting services - the frontend deploys to cPanel for static hosting, while the backend deploys to Render for cloud hosting. The application demonstrates a simple client-server architecture with API communication between a static HTML frontend and an Express.js backend.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture
- **Static Web Application**: Built with vanilla HTML, CSS, and JavaScript
- **Deployment Target**: cPanel static hosting
- **Development Server**: Express.js server for local development (port 5000)
- **API Communication**: Fetch API for making HTTP requests to backend
- **CORS Handling**: Backend configured to accept cross-origin requests

### Backend Architecture
- **Framework**: Express.js (Node.js)
- **Deployment Target**: Render cloud platform
- **Port Configuration**: Environment-based (PORT env var or 3001 default)
- **API Design**: RESTful JSON API
- **CORS Policy**: Permissive cross-origin configuration for frontend integration

### Development Workflow
- **Development Environment**: Replit-based coding
- **Version Control**: GitHub integration for code synchronization
- **Deployment Pipeline**: Manual deployment to respective hosting platforms
- **Local Testing**: Separate development servers for frontend and backend

### Project Structure
- **Modular Organization**: Clear separation of frontend and backend codebases
- **Database Schema**: Dedicated `db/` directory for SQL schemas and backups
- **Static Assets**: Self-contained frontend with embedded CSS and JavaScript

## External Dependencies

### Backend Dependencies
- **Express.js**: Web framework for Node.js applications
- **Body Parser**: HTTP request body parsing middleware
- **Built-in CORS**: Custom middleware for cross-origin resource sharing

### Frontend Dependencies
- **Express.js**: Development server for local static file serving
- **Native Web APIs**: Fetch API for HTTP communication

### Hosting Platforms
- **cPanel**: Static file hosting for frontend deployment
- **Render**: Cloud platform for backend API hosting
- **Replit**: Development environment and IDE

### Development Tools
- **GitHub**: Version control and code repository
- **Node.js**: Runtime environment for both frontend dev server and backend
- **npm**: Package management for dependencies