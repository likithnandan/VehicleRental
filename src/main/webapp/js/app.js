document.addEventListener("DOMContentLoaded", function () {

    // 1. Smooth page entrance
    document.body.classList.add("page-loaded");

    // 2. Automatically hide alerts with data-auto-hide or default 5s
    document.querySelectorAll(".alert").forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = "opacity 0.4s ease, transform 0.4s ease";
            alert.style.opacity = "0";
            alert.style.transform = "translateY(-8px)";

            setTimeout(function () {
                if (alert.parentNode) {
                    alert.parentNode.removeChild(alert);
                }
            }, 400);
        }, 5000);
    });

    // 3. Confirmation for delete/cancel actions
    document.querySelectorAll("[data-confirm]").forEach(function (element) {
        element.addEventListener("click", function (event) {
            const message = element.getAttribute("data-confirm") || "Are you sure you want to continue?";
            if (!confirm(message)) {
                event.preventDefault();
                event.stopImmediatePropagation();
                return false;
            }
        });
    });

    // 4. Safe form submission (prevents double submits without freezing on validation errors)
    document.querySelectorAll("form").forEach(function (form) {
        form.addEventListener("submit", function (event) {
            // Check HTML5 validity first
            if (typeof form.checkValidity === "function" && !form.checkValidity()) {
                return; // Let browser show validation errors
            }

            const submitButtons = form.querySelectorAll('button[type="submit"], input[type="submit"]');
            submitButtons.forEach(function (button) {
                if (!button.dataset.originalText) {
                    button.dataset.originalText = button.innerText || button.value;
                }

                // Delay slight moment to allow submit event to proceed to servlet
                setTimeout(function () {
                    button.disabled = true;
                    if (button.tagName === "BUTTON") {
                        button.innerText = "Processing...";
                    } else {
                        button.value = "Processing...";
                    }
                }, 50);
            });
        });
    });

    // 5. Active navigation link highlighting
    const currentPath = window.location.pathname;
    document.querySelectorAll(".nav-links a").forEach(function (link) {
        const href = link.getAttribute("href");
        if (href && href !== "#" && currentPath.endsWith(href)) {
            link.classList.add("active");
        }
    });

    // 6. Dynamic booking price calculation
    const pickupInput = document.getElementById("pickupDate");
    const returnInput = document.getElementById("returnDate");
    const priceDisplay = document.getElementById("totalPriceDisplay") || document.getElementById("bookingTotal");
    const pricePerDayInput = document.getElementById("pricePerDayValue");

    if (pickupInput && returnInput && priceDisplay && pricePerDayInput) {
        const calculateTotal = function () {
            const pVal = pickupInput.value;
            const rVal = returnInput.value;
            const dailyRate = parseFloat(pricePerDayInput.value || "0");

            if (pVal && rVal && dailyRate > 0) {
                const pDate = new Date(pVal);
                const rDate = new Date(rVal);
                const diffTime = rDate.getTime() - pDate.getTime();
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

                if (diffDays >= 1) {
                    const total = diffDays * dailyRate;
                    priceDisplay.innerText = "₹" + total.toFixed(2) + " (" + diffDays + " day" + (diffDays > 1 ? "s" : "") + ")";
                } else {
                    priceDisplay.innerText = "Return date must be after pickup date";
                }
            }
        };

        pickupInput.addEventListener("change", calculateTotal);
        returnInput.addEventListener("change", calculateTotal);
    }

    // 7. Password match validation on forms with confirmPassword
    const confirmPass = document.getElementById("confirmPassword");
    const mainPass = document.getElementById("password") || document.getElementById("newPassword");

    if (confirmPass && mainPass) {
        const validatePass = function () {
            if (confirmPass.value !== mainPass.value) {
                confirmPass.setCustomValidity("Passwords do not match");
            } else {
                confirmPass.setCustomValidity("");
            }
        };

        confirmPass.addEventListener("input", validatePass);
        mainPass.addEventListener("input", validatePass);
    }
});