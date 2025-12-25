import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { promotionAPI, getImageUrl } from '../services/api';
import { authService } from '../services/auth';
import PromotionForm from './PromotionForm';
import './PromotionManagement.css';

const PromotionManagement = () => {
  const [promotions, setPromotions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editingPromotion, setEditingPromotion] = useState(null);

  useEffect(() => {
    loadPromotions();
  }, []);

  const loadPromotions = async () => {
    try {
      setLoading(true);
      const data = await promotionAPI.getAll();
      setPromotions(data);
      setError('');
    } catch (err) {
      setError('Failed to load promotions: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleCreate = () => {
    setEditingPromotion(null);
    setShowModal(true);
  };

  const handleEdit = (promotion) => {
    setEditingPromotion(promotion);
    setShowModal(true);
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this promotion?')) {
      return;
    }

    try {
      await promotionAPI.delete(id);
      loadPromotions();
    } catch (err) {
      alert('Failed to delete promotion: ' + err.message);
    }
  };

  const handleFormClose = () => {
    setShowModal(false);
    setEditingPromotion(null);
  };

  const handleFormSuccess = () => {
    handleFormClose();
    loadPromotions();
  };

  const formatDate = (dateString) => {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    });
  };

  const currentUser = authService.getUser();

  return (
    <div className="promotion-management">
      <nav className="navbar">
        <div className="navbar-brand">
          <Link to="/dashboard" className="back-link">← Back to Dashboard</Link>
          <h2>Promotion Management</h2>
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
            <h2 className="card-title">Promotions</h2>
            <button onClick={handleCreate} className="btn btn-primary">
              + Create Promotion
            </button>
          </div>

          {error && <div className="error-message">{error}</div>}

          {loading ? (
            <div className="loading">Loading promotions...</div>
          ) : (
            <div className="promotions-grid">
              {promotions.length === 0 ? (
                <div className="empty-state">
                  <div className="empty-icon">📋</div>
                  <h3>No promotions yet</h3>
                  <p>Create your first promotion to get started</p>
                  <button onClick={handleCreate} className="btn btn-primary">
                    Create Promotion
                  </button>
                </div>
              ) : (
                promotions.map((promotion) => (
                  <div key={promotion.id} className="promotion-card">
                    {promotion.bannerImagePath && (
                      <div className="promotion-image">
                        <img
                          src={getImageUrl(promotion.bannerImagePath)}
                          alt={promotion.name}
                          onError={(e) => {
                            e.target.src = 'https://via.placeholder.com/400x200?text=Image+Not+Found';
                          }}
                        />
                      </div>
                    )}
                    <div className="promotion-content">
                      <h3 className="promotion-name">{promotion.name}</h3>
                      <div className="promotion-dates">
                        <div className="date-item">
                          <span className="date-label">Start:</span>
                          <span className="date-value">{formatDate(promotion.startDate)}</span>
                        </div>
                        <div className="date-item">
                          <span className="date-label">End:</span>
                          <span className="date-value">{formatDate(promotion.endDate)}</span>
                        </div>
                      </div>
                      <div className="promotion-actions">
                        <button
                          onClick={() => handleEdit(promotion)}
                          className="btn btn-secondary btn-sm"
                        >
                          Edit
                        </button>
                        <button
                          onClick={() => handleDelete(promotion.id)}
                          className="btn btn-danger btn-sm"
                        >
                          Delete
                        </button>
                      </div>
                    </div>
                  </div>
                ))
              )}
            </div>
          )}
        </div>
      </div>

      {showModal && (
        <PromotionForm
          promotion={editingPromotion}
          onClose={handleFormClose}
          onSuccess={handleFormSuccess}
        />
      )}
    </div>
  );
};

export default PromotionManagement;

