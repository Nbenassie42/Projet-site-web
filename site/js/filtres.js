// Stockage dans des variables des éléments nécessaires aux fonctions
const inputFilter = document.getElementById("inputFilter");
const divFilters = document.getElementById("divFilters");
const checkBoxes = divFilters.querySelectorAll("input[type='checkbox']");
const divHeaderFilter = document.getElementById("divHeaderFilter");
const divBodyFilter = document.getElementById("divBodyFilter");
const spansProductNames = document.getElementsByClassName("product-name");
const spansProductTypes = document.getElementsByClassName("product-type");

let filterValue = "";
let idElementsFilteredByName = [];
let idElementsFilteredByType = [];

// Gestion de la recherche par saisie de texte
function filterByProductName() {
    for (const spanPN of spansProductNames) {
        if (
            spanPN.innerText
                .toLowerCase()
                .includes(filterValue.toLowerCase().trim())
        ) {
            idElementsFilteredByName = idElementsFilteredByName.filter(
                (idElmt) => {
                    return idElmt !== spanPN.closest(".col").id;
                }
            );
            if (!idElementsFilteredByType.includes(spanPN.closest(".col").id)) {
                spanPN.closest(".col").classList.remove("d-none");
            }
        } else {
            spanPN.closest(".col").classList.add("d-none");
            idElementsFilteredByName.indexOf(spanPN.closest(".col").id) ===
                -1 && idElementsFilteredByName.push(spanPN.closest(".col").id);
        }
    }
}

// Gestion des filtres par type de produit
function filterByProductType(checkbox) {
    for (const spanPT of spansProductTypes) {
        if (
            checkbox.nextElementSibling.innerText.toLowerCase() ===
            spanPT.innerText.toLowerCase().trim()
        ) {
            if (checkbox.checked) {
                idElementsFilteredByType = idElementsFilteredByType.filter(
                    (idElmt) => {
                        return idElmt !== spanPT.closest(".col").id;
                    }
                );
                if (
                    !idElementsFilteredByName.includes(
                        spanPT.closest(".col").id
                    )
                ) {
                    spanPT.closest(".col").classList.remove("d-none");
                }
            } else {
                spanPT.closest(".col").classList.add("d-none");
                idElementsFilteredByType.push(spanPT.closest(".col").id);
            }
        }
    }
}

// Ajout des écouteurs d'évènements là où c'est nécessaire
for (const checkbox of checkBoxes) {
    checkbox.addEventListener("change", () => {
        filterByProductType(checkbox);
    });
}

inputFilter.addEventListener("keyup", (e) => {
    filterValue = e.target.value;
    filterByProductName(filterValue);
});

// Affichage des filtres sur petis écrans
divHeaderFilter.addEventListener("click", () => {
    const vw = Math.max(
        document.documentElement.clientWidth || 0,
        window.innerWidth || 0
    );
    if (vw < 992) {
        if (divBodyFilter.classList.contains("visible")) {
            divBodyFilter.classList.remove("visible");
        } else {
            divBodyFilter.classList.add("visible");
        }
    }
});
