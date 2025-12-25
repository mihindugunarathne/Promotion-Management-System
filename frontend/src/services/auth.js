// Auth utility functions
export const authService = {
  // Save user data to localStorage
  setUser: (userData) => {
    localStorage.setItem('token', userData.token);
    localStorage.setItem('user', JSON.stringify({
      id: userData.id,
      username: userData.username,
      email: userData.email,
      role: userData.role
    }));
  },

  // Get current user from localStorage
  getUser: () => {
    const userStr = localStorage.getItem('user');
    return userStr ? JSON.parse(userStr) : null;
  },

  // Get auth token
  getToken: () => {
    return localStorage.getItem('token');
  },

  // Check if user is authenticated
  isAuthenticated: () => {
    return !!localStorage.getItem('token');
  },

  // Check if user is admin
  isAdmin: () => {
    const user = authService.getUser();
    return user && user.role === 'ADMIN';
  },

  // Logout
  logout: () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
  }
};

