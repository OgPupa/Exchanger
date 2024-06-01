const sendFormRequest = async (url, formId, successHandler) => {
    try {
        const formData = new FormData(document.getElementById(formId));
        const response = await fetch(url, {
            method: 'POST',
            body: formData
        });

        const result = await response.json();

        alert(result.message);

        if (response.ok && result.status === 'success') {
            successHandler();
        }
    } catch (error) {
        alert(`Network error: ${error.message}`);
    }
};

document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('registerForm').addEventListener('submit', (event) => {
        event.preventDefault();
        sendFormRequest('/reg', 'registerForm', () => {
            window.location.href = "/login";
        });
    });
});
