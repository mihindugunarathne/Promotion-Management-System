import React, { useState, useEffect } from 'react';
import { promotionAPI, getImageUrl } from '../services/api';
import './PromotionForm.css';

const PromotionForm = ({ promotion, onClose, onSuccess }) => {
  const [formData, setFormData] = useState({
    name: '',
    startDate: '',
    endDate: ''
  });
  const [file, setFile] = useState(null);
  const [preview, setPreview] = useState(null);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (promotion) {
      setFormData({
        name: promotion.name || '',
        startDate: promotion.startDate || '',
        endDate: promotion.endDate || ''
      });
      if (promotion.bannerImagePath) {
        setPreview(getImageUrl(promotion.bannerImagePath));
      }
    }
  }, [promotion]);

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
    setError('');
  };

  const handleFileChange = (e) => {
    const selectedFile = e.target.files[0];
    if (selectedFile) {
      // Validate file type
      if (!selectedFile.type.startsWith('image/')) {
        setError('Please select an image file');
        return;
      }
      // Validate file size (10MB)
      if (selectedFile.size > 10 * 1024 * 1024) {
        setError('File size must be less than 10MB');
        return;
      }
      setFile(selectedFile);
      setError('');
      // Create preview
      const reader = new FileReader();
      reader.onloadend = () => {
        setPreview(reader.result);
      };
      reader.readAsDataURL(selectedFile);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    // Validate dates
    if (new Date(formData.startDate) > new Date(formData.endDate)) {
      setError('End date must be after start date');
      return;
    }

    setLoading(true);

    try {
      if (promotion) {
        await promotionAPI.update(promotion.id, formData, file);
      } else {
        await promotionAPI.create(formData, file);
      }
      onSuccess();
    } catch (err) {
      setError(err.message || 'Failed to save promotion');
    } finally {
      setLoading(false);
    }
  };

  const today = new Date().toISOString().split('T')[0];

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content promotion-modal" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3 className="modal-title">
            {promotion ? 'Edit Promotion' : 'Create New Promotion'}
          </h3>
          <button className="close-btn" onClick={onClose}>×</button>
        </div>

        <form onSubmit={handleSubmit}>
          {error && <div className="error-message">{error}</div>}

          <div className="form-group">
            <label htmlFor="name">Promotion Name *</label>
            <input
              type="text"
              id="name"
              name="name"
              className="form-control"
              value={formData.name}
              onChange={handleChange}
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="startDate">Start Date *</label>
            <input
              type="date"
              id="startDate"
              name="startDate"
              className="form-control"
              value={formData.startDate}
              onChange={handleChange}
              min={today}
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="endDate">End Date *</label>
            <input
              type="date"
              id="endDate"
              name="endDate"
              className="form-control"
              value={formData.endDate}
              onChange={handleChange}
              min={formData.startDate || today}
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="file">Banner Image (Optional)</label>
            <input
              type="file"
              id="file"
              name="file"
              className="form-control file-input"
              accept="image/*"
              onChange={handleFileChange}
            />
            <small className="file-hint">Max file size: 10MB. Supported formats: JPG, PNG, GIF</small>
          </div>

          {preview && (
            <div className="image-preview">
              <img src={preview} alt="Preview" />
              {file && (
                <button
                  type="button"
                  onClick={() => {
                    setFile(null);
                    setPreview(promotion?.bannerImagePath ? getImageUrl(promotion.bannerImagePath) : null);
                  }}
                  className="btn btn-secondary btn-sm"
                >
                  Remove New Image
                </button>
              )}
            </div>
          )}

          <div className="form-actions">
            <button
              type="button"
              onClick={onClose}
              className="btn btn-secondary"
              disabled={loading}
            >
              Cancel
            </button>
            <button
              type="submit"
              className="btn btn-primary"
              disabled={loading}
            >
              {loading ? 'Saving...' : promotion ? 'Update' : 'Create'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default PromotionForm;

