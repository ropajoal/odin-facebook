import { Controller } from "@hotwired/stimulus"
import * as React from 'react'
import { createRoot } from "react-dom/client"
import ChatManager from "./../components/ChatManager"

// Connects to data-controller="chat-react"
export default class extends Controller {
  connect() {
    const authenticityToken = this.data.get("authenticity-token");
    const friends = JSON.parse(this.data.get("friends"));
    const userId = this.data.get("user_id");

    createRoot(this.element).render(<ChatManager authenticityToken={authenticityToken} friends={friends} userId={userId}/>);
  }
}
