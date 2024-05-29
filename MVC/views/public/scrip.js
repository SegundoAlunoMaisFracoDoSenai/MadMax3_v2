const plants = [
    { name: 'Rosa', description: 'Uma flor bonita e perfumada.' },
    { name: 'Girassol', description: 'Conhecida por seguir a direção do sol.' },
    { name: 'Tulipa', description: 'Uma planta bulbosa com flores coloridas.' },
    { name: 'Orquídea', description: 'Plantas exóticas e elegantes.' },
    { name: 'Margarida', description: 'Flor simples e muito popular em jardins.' }
];

function searchPlant() {
    const query = document.getElementById('search-bar').value.toLowerCase();
    const resultsContainer = document.getElementById('results');
    resultsContainer.innerHTML = '';

    const results = plants.filter(plant => plant.name.toLowerCase().includes(query));
    
    if (results.length > 0) {
        results.forEach(plant => {
            const plantElement = document.createElement('div');
            plantElement.className = 'plant';

            const highlightedName = highlightText(plant.name, query);
            const description = plant.description;

            plantElement.innerHTML = `
                <h3>${highlightedName}</h3>
                <p>${description}</p>
                <button onclick="showMoreInfo('${plant.name}')">Mais informações</button>
            `;
            resultsContainer.appendChild(plantElement);
        });
    } else {
        resultsContainer.innerHTML = '<p>Nenhuma planta encontrada.</p>';
    }
}

function highlightText(text, query) {
    if (!query) return text;

    const regex = new RegExp(`(${query})`, 'gi');
    return text.replace(regex, '<span class="highlight">$1</span>');
}

function showMoreInfo(plantName) {
    alert(`Mais informações sobre ${plantName}`);
}

// Seleciona todos os elementos com a classe 'btnRedirecionar'
const btnredirect = document.querySelectorAll('.redirect');

// Itera sobre cada botão e adiciona um ouvinte de evento para o clique
redirect.forEach(function(botao) {
  botao.addEventListener('click', function() {
    // Redireciona para outra página no localhost
    window.location.href = 'http://localhost:3008/detalhe.ejs';
  });
});

