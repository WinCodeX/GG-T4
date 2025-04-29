import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["stepContent"]

  connect() {
    this.currentStep = 0
    this.formData = {}

    // Read preloaded data from HTML button
    const triggerButton = document.querySelector('[data-agents]')
    const locationButton = document.querySelector('[data-locations]')
    const courierButton = document.querySelector('[data-couriers]')

    this.agents = JSON.parse(triggerButton?.dataset?.agents || "[]")
    this.locations = JSON.parse(locationButton?.dataset?.locations || "[]")
    this.couriers = JSON.parse(courierButton?.dataset?.couriers || "[]")

    this.setupSteps()
    this.loadStep()
  }

  setupSteps() {
    this.steps = [
      this.recipientStep.bind(this),
      this.senderAgentStep.bind(this),
      this.deliveryTypeStep.bind(this),
      this.deliveryDetailsStep.bind(this),
      this.reviewConfirmStep.bind(this)
    ]
  }

  loadStep() {
    if (this.stepContentTarget) {
      this.stepContentTarget.innerHTML = this.steps[this.currentStep]()
    }
  }

  nextStep() {
    if (this.currentStep < this.steps.length - 1) {
      this.currentStep++
      this.loadStep()
    }
  }

  prevStep() {
    if (this.currentStep > 0) {
      this.currentStep--
      this.loadStep()
    }
  }

  closeModal() {
    this.element.classList.add('hidden')
  }

  saveInput(event) {
    const field = event.target.name
    const value = event.target.value

    this.formData[field] = value
  }

  handleDeliveryTypeChange(event) {
    this.saveInput(event)
    this.loadStep()
  }

  // ============ STEP 1: Recipient Info ==============

  recipientStep() {
    return `
      <div>
        <label class="block mb-2 text-sm">Recipient Name</label>
        <input type="text" name="recipient_name" value="${this.formData.recipient_name || ''}" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="input->create-package#saveInput" placeholder="Enter name">

        <label class="block mb-2 text-sm mt-4">Recipient Phone</label>
        <input type="text" name="recipient_phone" value="${this.formData.recipient_phone || ''}" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="input->create-package#saveInput" placeholder="Enter phone number">
      </div>
    `
  }

  // ============ STEP 2: Sender Agent ==============

  senderAgentStep() {
    const agentOptions = this.agents.map(agent =>
      `<option value="${agent.id}" ${this.formData.sender_agent_id == agent.id ? 'selected' : ''}>${agent.name}</option>`
    ).join('')

    return `
      <div>
        <label class="block mb-2 text-sm">Sender Agent</label>
        <select name="sender_agent_id" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="change->create-package#saveInput">
          <option value="">Select an agent...</option>
          ${agentOptions}
        </select>
      </div>
    `
  }

  // ============ STEP 3: Delivery Type ==============

  deliveryTypeStep() {
    const selected = this.formData.delivery_type

    return `
      <div>
        <label class="block mb-2 text-sm">Delivery Type</label>
        <select name="delivery_type" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="change->create-package#handleDeliveryTypeChange">
          <option value="">Choose Delivery Type</option>
          <option value="door_delivery" ${selected === 'door_delivery' ? 'selected' : ''}>Door Delivery</option>
          <option value="agent_pickup" ${selected === 'agent_pickup' ? 'selected' : ''}>Agent Pickup</option>
          <option value="parcel_delivery" ${selected === 'parcel_delivery' ? 'selected' : ''}>Parcel Delivery</option>
        </select>
      </div>
    `
  }

  // ============ STEP 4: Delivery Details (Based on Type) ==============

  deliveryDetailsStep() {
    const type = this.formData.delivery_type

    if (!type) {
      return `<p class="text-gray-400">Please select a delivery type first.</p>`
    }

    if (type === "door_delivery") {
      const locationOptions = this.locations.map(location =>
        `<option value="${location.id}" ${this.formData.receiver_location_id == location.id ? 'selected' : ''}>${location.name}</option>`
      ).join('')

      return `
        <div>
          <label class="block mb-2 text-sm">Receiver Location</label>
          <select name="receiver_location_id" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="change->create-package#saveInput">
            <option value="">Select location...</option>
            ${locationOptions}
          </select>

          <label class="block mb-2 text-sm mt-4">Exact Location</label>
          <textarea name="exact_location" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="input->create-package#saveInput" placeholder="Apartment / Street">${this.formData.exact_location || ''}</textarea>
        </div>
      `
    }

    if (type === "agent_pickup") {
      const agentOptions = this.agents.map(agent =>
        `<option value="${agent.id}" ${this.formData.receiver_agent_id == agent.id ? 'selected' : ''}>${agent.name}</option>`
      ).join('')

      return `
        <div>
          <label class="block mb-2 text-sm">Receiver Agent</label>
          <select name="receiver_agent_id" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="change->create-package#saveInput">
            <option value="">Select receiver agent...</option>
            ${agentOptions}
          </select>
        </div>
      `
    }

    if (type === "parcel_delivery") {
      const courierOptions = this.couriers.map(courier =>
        `<option value="${courier.id}" ${this.formData.courier_service_id == courier.id ? 'selected' : ''}>${courier.name}</option>`
      ).join('')

      return `
        <div>
          <label class="block mb-2 text-sm">Courier Service</label>
          <select name="courier_service_id" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="change->create-package#saveInput">
            <option value="">Select courier...</option>
            ${courierOptions}
          </select>

          <label class="block mb-2 text-sm mt-4">Destination</label>
          <input type="text" name="destination" value="${this.formData.destination || ''}" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" placeholder="Destination" data-action="input->create-package#saveInput">
        </div>
      `
    }
  }

  // ============ STEP 5: Review Step ==============

  reviewConfirmStep() {
    const deliveryFee = this.calculateDeliveryFee()

    const agentOptions = this.agents.map(agent =>
      `<option value="${agent.id}" ${this.formData.sender_agent_id == agent.id ? 'selected' : ''}>${agent.name}</option>`
    ).join('')

    const receiverAgentOptions = this.agents.map(agent =>
      `<option value="${agent.id}" ${this.formData.receiver_agent_id == agent.id ? 'selected' : ''}>${agent.name}</option>`
    ).join('')

    const locationOptions = this.locations.map(location =>
      `<option value="${location.id}" ${this.formData.receiver_location_id == location.id ? 'selected' : ''}>${location.name}</option>`
    ).join('')

    const courierOptions = this.couriers.map(courier =>
      `<option value="${courier.id}" ${this.formData.courier_service_id == courier.id ? 'selected' : ''}>${courier.name}</option>`
    ).join('')

    return `
      <div class="space-y-6">
        <h2 class="text-2xl font-bold">Review & Confirm Package</h2>

        <div>
          <label class="block mb-2 text-sm">Recipient Name</label>
          <input type="text" name="recipient_name" value="${this.formData.recipient_name || ''}" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="input->create-package#saveInput">
        </div>

        <div>
          <label class="block mb-2 text-sm">Recipient Phone</label>
          <input type="text" name="recipient_phone" value="${this.formData.recipient_phone || ''}" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="input->create-package#saveInput">
        </div>

        <div>
          <label class="block mb-2 text-sm">Sender Agent</label>
          <select name="sender_agent_id" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="change->create-package#saveInput">
            ${agentOptions}
          </select>
        </div>

        <div>
          <label class="block mb-2 text-sm">Delivery Type</label>
          <select name="delivery_type" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="change->create-package#handleDeliveryTypeChange">
            <option value="">Select...</option>
            <option value="door_delivery" ${this.formData.delivery_type == 'door_delivery' ? 'selected' : ''}>Door Delivery</option>
            <option value="agent_pickup" ${this.formData.delivery_type == 'agent_pickup' ? 'selected' : ''}>Agent Pickup</option>
            <option value="parcel_delivery" ${this.formData.delivery_type == 'parcel_delivery' ? 'selected' : ''}>Parcel Delivery</option>
          </select>
        </div>

        ${this.renderDeliveryTypeSpecificFields(locationOptions, receiverAgentOptions, courierOptions)}

        <div class="border-t border-gray-700 mt-8 pt-6">
          <h3 class="text-lg font-semibold mb-2">Delivery Fee Estimate</h3>
          <p class="text-2xl font-bold text-green-400">KES ${deliveryFee}</p>
        </div>

        <button class="w-full bg-[#6b46c1] text-white py-3 rounded hover:bg-[#9f7aea] mt-6" data-action="click->create-package#submitForm">
          Submit Package
        </button>
      </div>
    `
  }

  renderDeliveryTypeSpecificFields(locationOptions, receiverAgentOptions, courierOptions) {
    const type = this.formData.delivery_type

    if (type === "door_delivery") {
      return `
        <div>
          <label class="block mb-2 text-sm">Receiver Location</label>
          <select name="receiver_location_id" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="change->create-package#saveInput">
            ${locationOptions}
          </select>

          <label class="block mb-2 text-sm mt-4">Exact Location</label>
          <textarea name="exact_location" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="input->create-package#saveInput">${this.formData.exact_location || ''}</textarea>
        </div>
      `
    }

    if (type === "agent_pickup") {
      return `
        <div>
          <label class="block mb-2 text-sm">Receiver Agent</label>
          <select name="receiver_agent_id" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="change->create-package#saveInput">
            ${receiverAgentOptions}
          </select>
        </div>
      `
    }

    if (type === "parcel_delivery") {
      return `
        <div>
          <label class="block mb-2 text-sm">Courier Service</label>
          <select name="courier_service_id" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" data-action="change->create-package#saveInput">
            ${courierOptions}
          </select>

          <label class="block mb-2 text-sm mt-4">Destination</label>
          <input type="text" name="destination" value="${this.formData.destination || ''}" class="w-full p-2 rounded bg-[#282a36] border border-[#6b46c1]" placeholder="Destination details" data-action="input->create-package#saveInput">
        </div>
      `
    }

    return ""
  }

  calculateDeliveryFee() {
    const type = this.formData.delivery_type

    if (type === "door_delivery") return 300
    if (type === "agent_pickup") return 200
    if (type === "parcel_delivery") return 500

    return 0
  }

submitForm() {
  const submitButton = this.stepContentTarget.querySelector("button[data-action='click->create-package#submitForm']")
  submitButton.disabled = true
  submitButton.textContent = "Submitting..."

  const formData = new FormData()
  for (const key in this.formData) {
    if (this.formData.hasOwnProperty(key)) {
      formData.append(`package[${key}]`, this.formData[key])
    }
  }

  fetch('/packages', {
    method: 'POST',
    headers: {
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    },
    body: formData
  })
  .then(response => {
    if (response.ok) {
      return response.json()
    } else {
      throw new Error("Package creation failed")
    }
  })
  .then(data => {
    console.log("Package created successfully:", data)
    alert("Package created successfully!")
    this.closeModal()
  })
  .catch(error => {
    console.error("Error creating package:", error)
    alert("Failed to create package. Please try again.")
  })
  .finally(() => {
    submitButton.disabled = false
    submitButton.textContent = "Submit Package"
  })
}
}