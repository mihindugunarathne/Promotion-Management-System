import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { userAPI } from '../services/api';
import { authService } from '../services/auth';
import UserForm from './UserForm';
import './UserManagement.css';

const UserManagement = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editingUser, setEditingUser] = useState(null);

  useEffect(() => {
    loadUsers();
  }, []);

  const loadUsers = async () => {
    try {
      setLoading(true);
      const data = await userAPI.getAll();
      setUsers(data);
      setError('');
    } catch (err) {
      setError('Failed to load users: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleCreate = () => {
    setEditingUser(null);
    setShowModal(true);
  };

  const handleEdit = (user) => {
    setEditingUser(user);
    setShowModal(true);
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this user?')) {
      return;
    }

    try {
      await userAPI.delete(id);
      loadUsers();
    } catch (err) {
      alert('Failed to delete user: ' + err.message);
    }
  };

  const handleFormClose = () => {
    setShowModal(false);
    setEditingUser(null);
  };

  const handleFormSuccess = () => {
    handleFormClose();
    loadUsers();
  };

  const currentUser = authService.getUser();

  return (
    <div className="user-management">
      <nav className="navbar">
        <div className="navbar-brand">
          <Link to="/dashboard" className="back-link">← Back to Dashboard</Link>
          <h2>User Management</h2>
        </div>
        <div className="navbar-menu">
          <div className="user-info">
            <span className="username">{currentUser?.username}</span>
            <span className="user-role">{currentUser?.role}</span>
          </div>
        </div>
      </nav>

      <div className="content-container">
        <div className="card">
          <div className="card-header">
            <h2 className="card-title">Users</h2>
            <button onClick={handleCreate} className="btn btn-primary">
              + Add New User
            </button>
          </div>

          {error && <div className="error-message">{error}</div>}

          {loading ? (
            <div className="loading">Loading users...</div>
          ) : (
            <div className="table-container">
              <table>
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {users.length === 0 ? (
                    <tr>
                      <td colSpan="6" style={{ textAlign: 'center', padding: '40px' }}>
                        No users found
                      </td>
                    </tr>
                  ) : (
                    users.map((user) => (
                      <tr key={user.id}>
                        <td>{user.id}</td>
                        <td>{user.username}</td>
                        <td>{user.email}</td>
                        <td>
                          <span className={`role-badge ${user.role.toLowerCase()}`}>
                            {user.role}
                          </span>
                        </td>
                        <td>
                          <span className={`status-badge ${user.isActive ? 'active' : 'inactive'}`}>
                            {user.isActive ? 'Active' : 'Inactive'}
                          </span>
                        </td>
                        <td>
                          <div className="action-buttons">
                            <button
                              onClick={() => handleEdit(user)}
                              className="btn btn-secondary btn-sm"
                            >
                              Edit
                            </button>
                            {user.id !== currentUser?.id && (
                              <button
                                onClick={() => handleDelete(user.id)}
                                className="btn btn-danger btn-sm"
                              >
                                Delete
                              </button>
                            )}
                          </div>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>

      {showModal && (
        <UserForm
          user={editingUser}
          onClose={handleFormClose}
          onSuccess={handleFormSuccess}
        />
      )}
    </div>
  );
};

export default UserManagement;

