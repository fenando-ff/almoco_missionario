function getCookie(name) {
  const v = document.cookie.match('(^|;)\\s*' + name + '\\s*=\\s*([^;]+)');
  return v ? v.pop() : '';
}

function buildCalendar(){
  const cal = document.getElementById('calendar');
  cal.innerHTML = '';
  // compute days in month and first weekday (Sunday=0)
  const daysInMonth = new Date(YEAR, MONTH, 0).getDate();
  const firstWeekday = new Date(YEAR, MONTH-1, 1).getDay(); // 0=Sunday
  const offset = firstWeekday; // Sunday-first calendar
  const totalCells = offset + daysInMonth;
  for(let i=0;i<totalCells;i++){
    const block = document.createElement('div');
    if(i < offset){
      block.className = 'day-block empty';
      cal.appendChild(block);
      continue;
    }
    const dayNum = i - offset + 1;
    block.className = 'day-block';
    const dn = document.createElement('div'); dn.className='day-number'; dn.textContent = dayNum;
    block.appendChild(dn);

    const yyyy = String(YEAR).padStart(4,'0');
    const mm = String(MONTH).padStart(2,'0');
    const dd = String(dayNum).padStart(2,'0');
    const iso = `${yyyy}-${mm}-${dd}`;

    if(RESERVATIONS && RESERVATIONS[iso]){
      // show a reserved icon instead of full text inside the calendar cell
      const icon = document.createElement('div');
      icon.className = 'reserved-icon';
      // tooltip with details for desktop; mobile can open modal to view details
      icon.title = `${RESERVATIONS[iso].nome} - ${RESERVATIONS[iso].telefone}`;
      // accessible text for screen readers
      icon.setAttribute('aria-label', `Reservado por ${RESERVATIONS[iso].nome}`);
      // use FontAwesome utensils icon
      const i = document.createElement('i');
      i.className = 'fa-solid fa-utensils';
      i.setAttribute('aria-hidden', 'true');
      icon.appendChild(i);
      block.appendChild(icon);
    }

    block.addEventListener('click', ()=>openModal(iso, block));
    cal.appendChild(block);
  }
}

function openModal(iso, block){
  document.getElementById('form-dia').value = iso;
  const existing = RESERVATIONS[iso];
  const deleteBtn = document.getElementById('delete-btn');
  const confirmBtn = document.getElementById('confirm-btn');
  const modalMessage = document.getElementById('modal-message');
  const modalPerson = document.getElementById('modal-person');
  const personName = document.getElementById('person-name');
  const personPhone = document.getElementById('person-phone');

  if(existing){
    // show person details and desmarcar
    modalMessage.textContent = 'Dia reservado por:';
    personName.textContent = existing.nome;
    personPhone.textContent = existing.telefone;
    modalPerson.classList.remove('hidden');
    // only show delete button if reservation is owned by current user
    if(existing.owned){
      deleteBtn.classList.remove('hidden');
    }else{
      deleteBtn.classList.add('hidden');
    }
    // can't book a day already reserved by someone else
    confirmBtn.classList.add('hidden');
  }else{
    // confirm booking flow
    modalMessage.textContent = 'Deseja agendar neste dia?';
    modalPerson.classList.add('hidden');
    deleteBtn.classList.add('hidden');
    confirmBtn.classList.remove('hidden');
  }
  document.getElementById('modal').classList.remove('hidden');
}

function refreshCalendar(){
  // update month title
  const title = document.getElementById('month-title');
  title.textContent = `${MONTHS_PT[MONTH-1]} ${YEAR}`;
  // fetch reservations for current month
  return (async ()=>{
    try{
      const res = await fetch(`/api/reservations/?year=${YEAR}&month=${MONTH}`);
      if(res.ok){
        RESERVATIONS = await res.json();
      }else{
        RESERVATIONS = {};
      }
    }catch(e){
      RESERVATIONS = {};
    }
    buildCalendar();
  })();
}

function closeModal(){
  document.getElementById('modal').classList.add('hidden');
}

document.addEventListener('DOMContentLoaded', ()=>{
  // fetch reservations for current month from server
  refreshCalendar();
  // setup month navigation
  document.getElementById('prev-month').addEventListener('click', ()=>{
    MONTH -= 1;
    if(MONTH < 1){ YEAR -= 1; MONTH = 12; }
    refreshCalendar();
  });
  document.getElementById('next-month').addEventListener('click', ()=>{
    MONTH += 1;
    if(MONTH > 12){ YEAR += 1; MONTH = 1; }
    refreshCalendar();
  });
  // set initial month title
  const title = document.getElementById('month-title');
  if(title){ title.textContent = `${MONTHS_PT[MONTH-1]} ${YEAR}`; }
  document.getElementById('cancel-btn').addEventListener('click', closeModal);
  document.getElementById('delete-btn').addEventListener('click', async ()=>{
    const dia = document.getElementById('form-dia').value;
    const ok = await showConfirm('Deseja desmarcar este dia?');
    if(!ok) return;
    const token = getCookie('csrftoken');
    try{
      const res = await fetch('/api/delete/', {
        method: 'POST',
        headers: {'Content-Type':'application/json','X-CSRFToken': token},
        body: JSON.stringify({dia})
      });
      if(!res.ok) throw new Error(await res.text());
      const data = await res.json();
      delete RESERVATIONS[data.dia];
      buildCalendar();
      closeModal();
    }catch(err){
      alert('Erro: '+err.message);
    }
  });
  // confirm booking (send only dia; backend uses session Pessoa)
  document.getElementById('confirm-btn').addEventListener('click', async ()=>{
    const dia = document.getElementById('form-dia').value;
    const token = getCookie('csrftoken');
    try{
      const res = await fetch('/api/save/', {
        method: 'POST',
        headers: {'Content-Type':'application/json','X-CSRFToken': token},
        body: JSON.stringify({dia})
      });
      if(!res.ok) throw new Error(await res.text());
      const data = await res.json();
      // mark as owned so delete button shows immediately
      RESERVATIONS[data.dia] = {nome: data.nome, telefone: data.telefone, owned: (data.owned === true)};
      buildCalendar();
      closeModal();
    }catch(err){
      alert('Erro: '+err.message);
    }
  });
  // confirm modal logic
  const confirmModal = document.getElementById('confirm-modal');
  const confirmMsg = document.getElementById('confirm-message');
  const btnOk = document.getElementById('confirm-ok');
  const btnCancel = document.getElementById('confirm-cancel');
  let confirmResolver = null;

  function showConfirm(message){
    return new Promise((resolve)=>{
      confirmResolver = resolve;
      confirmMsg.textContent = message;
      confirmModal.classList.remove('hidden');
    });
  }

  btnOk.addEventListener('click', ()=>{
    confirmModal.classList.add('hidden');
    if(confirmResolver) confirmResolver(true);
    confirmResolver = null;
  });
  btnCancel.addEventListener('click', ()=>{
    confirmModal.classList.add('hidden');
    if(confirmResolver) confirmResolver(false);
    confirmResolver = null;
  });

  // Export calendar to PDF
  const exportBtn = document.getElementById('export-pdf');
  if(exportBtn){
    exportBtn.addEventListener('click', ()=>{
      exportCalendarPdf();
    });
  }
});

function exportCalendarPdf(){
  // Build a printable wrapper with month title, weekdays and calendar
  const wrapper = document.createElement('div');
  wrapper.style.padding = '12px';
  wrapper.style.fontFamily = 'Arial, Helvetica, sans-serif';
  wrapper.style.color = '#111';

  const title = document.createElement('h2');
  title.textContent = `${MONTHS_PT[MONTH-1]} ${YEAR}`;
  title.style.textAlign = 'center';
  title.style.margin = '0 0 12px 0';
  title.style.fontSize = '18px';
  wrapper.appendChild(title);

  const weekdays = document.querySelector('.weekdays');
  const calendar = document.getElementById('calendar');
  if(weekdays) wrapper.appendChild(weekdays.cloneNode(true));
  if(calendar) wrapper.appendChild(calendar.cloneNode(true));

  // Enhance cloned calendar: insert owner name and phone into each day-block for export
  const calClone = wrapper.querySelector('.calendar');
  if(calClone){
    // Ensure weekday labels and calendar grid align in the PDF
    const wkClone = wrapper.querySelector('.weekdays');
    if(wkClone){
      wkClone.style.display = 'grid';
      wkClone.style.gridTemplateColumns = 'repeat(7, 1fr)';
      wkClone.style.gap = '8px';
      wkClone.style.width = '100%';
      wkClone.style.boxSizing = 'border-box';
      wkClone.style.margin = '0 0 6px 0';
      wkClone.style.padding = '0';
    }

    calClone.style.display = 'grid';
    calClone.style.gridTemplateColumns = 'repeat(7, 1fr)';
    calClone.style.gap = '8px';
    calClone.style.width = '100%';
    calClone.style.boxSizing = 'border-box';
    calClone.style.margin = '0';

    const blocks = calClone.querySelectorAll('.day-block');
    blocks.forEach((block)=>{
      if(block.classList.contains('empty')) return;
      // remove reserved icon in cloned block so PDF shows only text
      const existingIcon = block.querySelector('.reserved-icon');
      if(existingIcon) existingIcon.remove();

      // add border and padding to visually separate day blocks in PDF
      block.style.border = '1px solid #ddd';
      block.style.borderRadius = '6px';
      block.style.padding = '6px';
      block.style.minHeight = '54px';
      block.style.boxSizing = 'border-box';

      const dn = block.querySelector('.day-number');
      if(!dn) return;
      // make day number flow with document in cloned version so text below gets space
      dn.style.position = 'static';
      dn.style.display = 'block';
      dn.style.marginBottom = '10px';
      const dayNum = parseInt(dn.textContent, 10);
      if(isNaN(dayNum)) return;
      const yyyy = String(YEAR).padStart(4,'0');
      const mm = String(MONTH).padStart(2,'0');
      const dd = String(dayNum).padStart(2,'0');
      const iso = `${yyyy}-${mm}-${dd}`;
      const res = RESERVATIONS && RESERVATIONS[iso];
      if(res){
        // create a readable block with name and phone for PDF (larger font)
        const infoWrap = document.createElement('div');
        infoWrap.style.marginTop = '0';
        infoWrap.style.paddingTop = '0';
        infoWrap.style.fontSize = '12px';
        infoWrap.style.color = '#111';
        infoWrap.style.wordBreak = 'break-word';
        const nameEl = document.createElement('div');
        nameEl.textContent = res.nome || '';
        nameEl.style.fontWeight = '700';
        nameEl.style.fontSize = '12px';
        const phoneEl = document.createElement('div');
        phoneEl.textContent = res.telefone || '';
        phoneEl.style.fontSize = '11px';
        phoneEl.style.color = '#444';
        infoWrap.appendChild(nameEl);
        infoWrap.appendChild(phoneEl);
        block.appendChild(infoWrap);
      }
    });
  }

  const opt = {
    margin: 10,
    filename: `calendario-${MONTH}-${YEAR}.pdf`,
    image: { type: 'jpeg', quality: 0.98 },
    html2canvas: { scale: 2, useCORS: true },
    jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
  };

  // Use html2pdf to generate and save
  try{
    html2pdf().set(opt).from(wrapper).save();
  }catch(e){
    alert('Erro ao gerar PDF: '+e.message);
  }
}
