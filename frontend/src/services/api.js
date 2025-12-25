const API_BASE_URL = 'http://localhost:8080/api';

// Helper function to get auth token from localStorage
const getAuthToken = () => {
  return localStorage.getItem('token');
};

// Helper function to get auth headers
const getAuthHeaders = () => {
  const token = getAuthToken();
  return {
    'Content-Type': 'application/json',
    'Authorization': token ? `Bearer ${token}` : ''
  };
};

// Auth API
export const authAPI = {
  login: async (username, password) => {
    const response = await fetch(`${API_BASE_URL}/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ username, password })
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(error);
    }

    return await response.json();
  }
};

// User API (Admin only)
export const userAPI = {
  getAll: async () => {
    const response = await fetch(`${API_BASE_URL}/admin/users`, {
      method: 'GET',
      headers: getAuthHeaders()
    });

    if (!response.ok) {
      throw new Error('Failed to fetch users');
    }

    return await response.json();
  },

  getById: async (id) => {
    const response = await fetch(`${API_BASE_URL}/admin/users/${id}`, {
      method: 'GET',
      headers: getAuthHeaders()
    });

    if (!response.ok) {
      throw new Error('Failed to fetch user');
    }

    return await response.json();
  },

  create: async (userData) => {
    const response = await fetch(`${API_BASE_URL}/admin/users`, {
      method: 'POST',
      headers: getAuthHeaders(),
      body: JSON.stringify(userData)
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(error);
    }

    return await response.json();
  },

  update: async (id, userData) => {
    const response = await fetch(`${API_BASE_URL}/admin/users/${id}`, {
      method: 'PUT',
      headers: getAuthHeaders(),
      body: JSON.stringify(userData)
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(error);
    }

    return await response.json();
  },

  delete: async (id) => {
    const response = await fetch(`${API_BASE_URL}/admin/users/${id}`, {
      method: 'DELETE',
      headers: getAuthHeaders()
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(error);
    }

    return await response.text();
  }
};

// Promotion API
export const promotionAPI = {
  getAll: async () => {
    const response = await fetch(`${API_BASE_URL}/promotions`, {
      method: 'GET',
      headers: getAuthHeaders()
    });

    if (!response.ok) {
      throw new Error('Failed to fetch promotions');
    }

    return await response.json();
  },

  getById: async (id) => {
    const response = await fetch(`${API_BASE_URL}/promotions/${id}`, {
      method: 'GET',
      headers: getAuthHeaders()
    });

    if (!response.ok) {
      throw new Error('Failed to fetch promotion');
    }

    return await response.json();
  },

  create: async (promotionData, file) => {
    const formData = new FormData();
    formData.append('promotion', JSON.stringify(promotionData));
    if (file) {
      formData.append('file', file);
    }

    const token = getAuthToken();
    const response = await fetch(`${API_BASE_URL}/promotions`, {
      method: 'POST',
      headers: {
        'Authorization': token ? `Bearer ${token}` : ''
      },
      body: formData
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(error);
    }

    return await response.json();
  },

  update: async (id, promotionData, file) => {
    const formData = new FormData();
    formData.append('promotion', JSON.stringify(promotionData));
    if (file) {
      formData.append('file', file);
    }

    const token = getAuthToken();
    const response = await fetch(`${API_BASE_URL}/promotions/${id}`, {
      method: 'PUT',
      headers: {
        'Authorization': token ? `Bearer ${token}` : ''
      },
      body: formData
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(error);
    }

    return await response.json();
  },

  delete: async (id) => {
    const response = await fetch(`${API_BASE_URL}/promotions/${id}`, {
      method: 'DELETE',
      headers: getAuthHeaders()
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(error);
    }

    return await response.text();
  }
};

// Helper to get image URL
export const getImageUrl = (bannerImagePath) => {
  if (!bannerImagePath) return null;
  return `http://localhost:8080/uploads/${bannerImagePath}`;
};

