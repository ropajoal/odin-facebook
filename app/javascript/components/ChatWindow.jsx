import React, { useState, useEffect, useRef } from 'react'
import { csrfToken } from "@rails/ujs"
import consumer from '../channels/consumer'

export default function ChatWindow ({friend,userId}){

  const [messages, setMessages] = useState([]);
  //FIXME messagesContainer fix height
  const messagesContainer = document.getElementById("messages");
  const messagesRef = useRef(messages)

  useEffect(() => {
    fetchMessages();
    const subs = consumer.subscriptions.create({
      channel: "MessagesChannel",
      interId: friend.id
    },{
      received(data){
        setMessagesAndScrollDown([...(messagesRef.current),data])
      }
    })
  },[]);

  useEffect(() => {
    resetScroll();
    messagesRef.current = messages
  }, [messages]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    const body = e.target.message.value;
    e.target.message.value = "";
    debugger;
    await fetch("http://localhost:3000/messages.json", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-TOKEN": csrfToken()
      },
      body: JSON.stringify({ body, interId: friend.id })
    });
  };

  const fetchMessages = async () => {
    const response = await fetch("http://localhost:3000/messages.json?"+new URLSearchParams({interId: friend.id}));
    const data = await response.json();
    setMessagesAndScrollDown(data);
  };

  const setMessagesAndScrollDown = (data) => {
    setMessages(data);
    resetScroll();
  };

  const resetScroll = () => {
    if (!messagesContainer) return;
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  };

  return (
    <div className="messagesContainer collapse" id={"messages_"+friend.username}>
      <div className="messages" >
        {messages.map((message) => (
          <div className={"message " + ((message.sender == userId) ? "currentUserMes" : "interlocutorMes" )} key={message.id}>
            <p>{message.body}</p>
          </div>
        ))}
      </div>
      <div className="messageForm">
        <form onSubmit={handleSubmit}>
          <input className="messageInput" type="text" name="message" />
          <button className="messageButton" type="submit">
            Send
          </button>
        </form>
      </div>
    </div>
  )
}