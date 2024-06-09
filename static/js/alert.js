const sendFormRequestReceipt = async (url, formId, successHandler) => {
    try {
        const formData = new FormData(document.getElementById(formId));
        const response = await fetch(url, {
            method: 'POST',
            body: formData
        });

        if (!response.ok) {
            const result = await response.json();
            alert(result.message);
            return;
        }

        const blob = await response.blob();
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = 'receipt.pdf';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        if (successHandler) {
            successHandler();
        }
    } catch (error) {
        alert(`Network error: ${error.message}`);
    }
};

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

document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('loginForm').addEventListener('submit', (event) => {
        event.preventDefault();
        sendFormRequest('/login', 'loginForm', () => {
            window.location.href = "/cabinet";
        });
    });
});

document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('saveForm').addEventListener('submit', (event) => {
        event.preventDefault();
        sendFormRequestReceipt('/save', 'saveForm', () => {
            window.location.href = "/";
        });
    });
});