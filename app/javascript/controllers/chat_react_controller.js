import { Controller } from "@hotwired/stimulus"
import * as React from 'react'
import { createRoot } from "react-dom/client"
import Chat from "./../Chat"

// Connects to data-controller="chat-react"
export default class extends Controller {
  connect() {
    const authenticityToken = this.data.get("authenticity-token");
    const chatReact = document.getElementById("chatReact");
    createRoot(chatReact).render(<Chat authenticityToken={authenticityToken} />);
  }
}
