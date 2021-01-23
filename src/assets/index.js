document.addEventListener("DOMContentLoaded", () => {
  (function () {
    this.App || (this.App = {});

    App.cable = ActionCable.createConsumer(
      "ws://localhost:3000/cable?token=12345123" // if using the default options
    );
  }.call(this));

  App.channels || (App.channels = {});

  App.channels["chat_1"] = App.cable.subscriptions.create(
    {
      channel: "ChatChannel",
      room: "1",
    },
    {
      connected: function (data) {
        return console.log("ChatChannel connected", data);
      },
      disconnected: function (data) {
        return console.log("ChatChannel disconnected", data);
      },
      received: function (data) {
        console.log("ChatChannel received", data);
        const node = document.createElement("P");
        const textnode = document.createTextNode(data.message);
        node.appendChild(textnode);
        document.getElementById("chat-log").appendChild(node);
      },
      rejected: function () {
        return console.log("ChatChannel rejected");
      },
      away: function () {
        return this.perform("away");
      },
      status: function (status) {
        return this.perform("status", {
          status: status,
        });
      },
    }
  );

  const form = document.querySelector("form");

  form.addEventListener("submit", (e) => {
    e.preventDefault();

    const msg = document.getElementById("message");
    App.channels["chat_1"].send({ message: msg.value });
  });
});
