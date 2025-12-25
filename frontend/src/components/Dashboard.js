import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { authService } from '../services/auth';
import './Dashboard.css';

const Dashboard = ({ onLogout }) => {
  const navigate = useNavigate();
  const user = authService.getUser();
  const isAdmin = authService.isAdmin();

  const handleLogout = () => {
    onLogout();
    navigate('/login');
  };

  return (
    <div className="dashboard">
      <nav className="navbar">
        <div className="navbar-brand">
          <h2>Promotion Management System</h2>
        </div>
        <div className="navbar-menu">
          <div className="user-info">
            <span className="username">{user?.username}</span>
            <span className="user-role">{user?.role}</span>
          </div>
          <button onClick={handleLogout} className="btn btn-secondary btn-sm">
            Logout
          </button>
        </div>
      </nav>

      <div className="dashboard-content">
        <div className="dashboard-header">
          <h1>Welcome, {user?.username}!</h1>
          <p>Manage your promotions and users from here</p>
        </div>

        <div className="dashboard-cards">
          <Link to="/promotions" className="dashboard-card">
            <div className="card-icon">🎯</div>
            <h3>Promotions</h3>
            <p>Create, view, edit, and delete promotions</p>
          </Link>

          {isAdmin && (
            <Link to="/users" className="dashboard-card">
              <div className="card-icon">👥</div>
              <h3>User Management</h3>
              <p>Manage user accounts (Admin only)</p>
            </Link>
          )}
        </div>

        <div className="dashboard-stats">
          <div className="stat-card">
            <h4>Your Role</h4>
            <p className="stat-value">{user?.role}</p>
          </div>
          <div className="stat-card">
            <h4>Email</h4>
            <p className="stat-value-small">{user?.email}</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;

